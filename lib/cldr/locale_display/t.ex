defmodule Cldr.LocaleDisplay.T do
  @moduledoc false

  import Cldr.LocaleDisplay,
    only: [get_display_preference: 2, join_field_values: 2, replace_parens_with_brackets: 1]

  def display_name(transform, options) do
    {in_locale, _backend} = Cldr.locale_and_backend_from(options)
    module = Module.concat(in_locale.backend, :LocaleDisplay)
    {:ok, display_names} = module.display_names(in_locale)
    fields = Cldr.Validity.T.field_mapping() |> Map.delete("h0") |> Enum.sort()

    for {_key, field} <- fields, !is_nil(value = Map.get(transform, field)) do
      format_key_value(field, value, transform, in_locale, display_names, options[:prefer])
    end
    |> join_field_values(display_names)
  end

  # If the value is not known then use the value
  # from the struct and display the key as well
  def format_key_value(field, value, transform, in_locale, display_names, prefer) do
    if value_name = get(field, value, display_names) do
      replace_parens_with_brackets(value_name)
    else
      key_name = get_in(display_names, [:keys, field])
      display_value(field, key_name, value, transform, in_locale, display_names, prefer)
    end
  end

  # Returns the localised value for the key. If there is
  # no available key name then just return the value.

  defp display_value(:language, _key_name, value, transform, _in_locale, display_names, _prefer) do
    key_name =
      if transform.h0 == :hybrid,
        do: get_in(display_names, [:types, :h0, :hybrid]),
        else: get_in(display_names, [:keys, :t])

    value_name =
      value
      |> Cldr.display_name()
      |> replace_parens_with_brackets()

    if key_name do
      display_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])
      Cldr.Substitution.substitute([key_name, value_name], display_pattern)
    else
      value_name
    end
  end

  defp display_value(_key, nil, value, _transform, _in_locale, _display_names, _prefer)
       when is_binary(value) do
    replace_parens_with_brackets(value)
  end

  defp display_value(_key, nil, value, _transform, _in_locale, _display_names, _prefer)
       when is_atom(value) do
    value
    |> to_string()
    |> replace_parens_with_brackets()
  end

  defp display_value(key, key_name, value, transform, in_locale, display_names, prefer) do
    value_name =
      key
      |> get(key_name, value, transform, in_locale, display_names)
      |> Kernel.||(value)
      |> get_display_preference(prefer)
      |> :erlang.iolist_to_binary()
      |> replace_parens_with_brackets

    display_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])
    Cldr.Substitution.substitute([key_name, value_name], display_pattern)
  end

  defp get(:x0, _key_name, values, _transform, _in_locale, display_names) when is_list(values) do
    join_field_values(values, display_names)
  end

  defp get(:x0, _key_name, value, _transform, _in_locale, _display_names) do
    value
  end

  defp get(_key, key_name, value, _transform, _in_locale, display_names) do
    get_in(display_names, [:types, key_name, value])
  end

  defp get(field, [value], display_names) do
    get_in(display_names, [:types, field, value])
  end

  defp get(field, value, display_names) do
    get_in(display_names, [:types, field, value])
  end

  defimpl Cldr.DisplayName, for: Cldr.LanguageTag.T do
    def display_name(language_tag, options) do
      Cldr.LocaleDisplay.T.display_name(language_tag, options)
    end
  end
end
