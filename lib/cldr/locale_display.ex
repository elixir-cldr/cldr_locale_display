defmodule Cldr.LocaleDisplay do
  @moduledoc """
  Implements the CLDR locale display name algorithm to format
  a `t:Cldr.LanguageTag` struct for presentation uses.

  """

  @doc false
  def cldr_backend_provider(config) do
    Cldr.LocaleDisplay.Backend.define_locale_display_module(config)
  end

  import Cldr.LanguageTag, only: [empty?: 1]

  @doc """
  Returns a localised display name for a
  locale suitable for presentation
  requirements.

  """
  @basic_tag_order [:language, :script, :territory, :language_variants]
  @extension_order [:locale, :transform, :extensions]

  def display_name(language_tag, in_locale, options) do
    {:ok, display_names} =
      Module.concat(in_locale.backend, :LocaleDisplay).display_names(in_locale)

    match_tag =
      if options[:compound_locale], do: language_tag, else: simplify(language_tag)

    {language_name, matched_tags} =
      Cldr.Locale.first_match(match_tag,
        &language_match_fun(&1, &2, display_names.language), true) |> IO.inspect

    subtag_names =
      language_tag
      |> subtag_names(@basic_tag_order -- matched_tags, display_names, options[:prefer])
      |> join_subtags(display_names)

    extension_names =
      @extension_order
      |> Enum.map(&Cldr.DisplayName.display_name(Map.fetch!(language_tag, &1), in_locale, options))
      |> Enum.reject(&empty?/1)

    format_display_name(language_name, subtag_names, extension_names, display_names)
  end

  defp format_display_name(language_name, [], [], _display_names) do
    language_name
  end

  defp format_display_name(language_name, subtag_names, extension_names, display_names) do
    locale_pattern =
      get_in(display_names, [:locale_display_pattern, :locale_pattern])

    subtags =
      [subtag_names, extension_names]
      |> Enum.reject(&empty?/1)
      |> join_subtags(display_names)

    [language_name, subtags]
    |> Cldr.Substitution.substitute(locale_pattern)
    |> :erlang.iolist_to_binary
  end

  defp simplify(language_tag) do
    language_tag
    |> Map.put(:territory, nil)
  end

  defp subtag_names(_locale, [], _display_names, _preference) do
    []
  end

  defp subtag_names(locale, subtags, display_names, preference) do
    subtags
    |> Enum.map(&get_display_name(locale, display_names, &1, preference))
    |> Enum.reject(&empty?/1)
    |> join_subtags(display_names)
  end

  defp get_display_name(locale, display_names, subtag, preference) do
    case subtag_value = Map.fetch!(locale, subtag) do
      [_|_] = subtags ->
        Enum.map(subtags, fn value -> display_names[subtag][value] end)
      subtag ->
        display_names[subtag][subtag_value]
    end
    |> get_display_preference(preference)
  end

  @doc false
  def get_display_preference(value, _preference) when is_binary(value) do
    value
  end

  def get_display_preference(values, preference) when is_list(values) do
    Enum.map(values, &get_display_preference(&1, preference))
  end

  def get_display_preference(values, preference) when is_map(values) do
    Map.get(values, preference) || Map.fetch!(values, :default)
  end

  defp join_subtags([], _display_names) do
    []
  end

  defp join_subtags(fields, display_names) do
    join_pattern = get_in(display_names, [:locale_display_pattern, :locale_separator])
    Enum.reduce(fields, &Cldr.Substitution.substitute([&2, &1], join_pattern))
  end

  defp language_match_fun(locale_name, matched_tags, language_names) do
    if display_name = Map.get(language_names, locale_name) do
      {display_name, matched_tags}
    else
      nil
    end
  end

  defimpl Cldr.DisplayName, for: Cldr.LanguageTag do
    def display_name(language_tag, %Cldr.LanguageTag{} = in_locale, options) do
      Cldr.LocaleDisplay.display_name(language_tag, in_locale, options)
    end
  end

  defimpl Cldr.DisplayName, for: Map do
    def display_name(map, _in_locale, _options) when map == %{} do
      ""
    end
  end
end
