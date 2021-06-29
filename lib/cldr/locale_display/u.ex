defmodule Cldr.LocaleDisplay.U do
  @moduledoc """


  """

  import Cldr.LocaleDisplay, only: [get_display_preference: 2]

  def display_name(locale, in_locale, options) do
    module = Module.concat(in_locale.backend, :LocaleDisplay)
    {:ok, display_names} = module.display_names(in_locale)
    fields = Cldr.Validity.U.field_mapping() |> Enum.sort()

    for {_key, field} <- fields, !is_nil(value = Map.get(locale, field)) do
      format_key_value(field, value, locale, in_locale, display_names, options[:prefer])
    end
    |> join_field_values(display_names)
  end

  # If the value is not known then use the value
  # from the struct and display the key as well

  def format_key_value(field, value, locale, in_locale, display_names, preference) do
    if value_name = get_in(display_names, [:types, field, value]) do
      value_name
    else
      key_name = get_in(display_names, [:keys, field])
      display_value(field, key_name, value, locale, in_locale, display_names, preference)
    end
  end

  # Returns the localised value for the
  # key.

  defp display_value(:rg, key_name, value, _locale, _in_locale, display_names, preference) do
    value =
      Cldr.Validity.Territory.validate(value) |> elem(1)

    value_name =
      display_names
      |> get_in([:territory, value])
      |> Kernel.||(value)
      |> get_display_preference(preference)

    display_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])
    Cldr.Substitution.substitute([key_name, value_name], display_pattern)
  end

  # The subdivision translations live in the `ex_cldr_territories`
  # package

  defp display_value(:sd, key_name, value, _locale, in_locale, display_names, preference) do
    value = Cldr.Validity.Subdivision.validate(value) |> elem(1)
    subdivision_params = [value, in_locale.backend, [locale: in_locale]]

    value =
      case apply(Cldr.Territory, :from_subdivision_code, subdivision_params) do
        {:ok, value} -> value
        {:error, _} -> value
      end
      |> get_display_preference(preference)

    display_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])
    Cldr.Substitution.substitute([key_name, value], display_pattern)
  end

  defp display_value(:dx, key_name, value, _locale, _in_locale, display_names, preference) do
    value =
      Cldr.Validity.Script.validate(value) |> elem(1)

    value_name =
      display_names
      |> get_in([:script, value])
      |> Kernel.||(value)
      |> get_display_preference(preference)

    display_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])
    Cldr.Substitution.substitute([key_name, value_name], display_pattern)
  end

  defp display_value(_key, key_name, value, _locale, _in_locale, display_names, preference) do
    value_name =
      display_names
      |> get_in([:script, value])
      |> Kernel.||(value)
      |> get_display_preference(preference)

    display_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])
    Cldr.Substitution.substitute([key_name, value_name], display_pattern)
  end

  # Joins field values together using the
  # localised format

  def join_field_values(fields, display_names) do
    join_pattern = get_in(display_names, [:locale_display_pattern, :locale_separator])
    Enum.reduce(fields, &Cldr.Substitution.substitute([&2, &1], join_pattern))
  end

  defimpl Cldr.DisplayName, for: Cldr.LanguageTag.U do
    def display_name(language_tag, %Cldr.LanguageTag{} = in_locale, options) do
      Cldr.LocaleDisplay.U.display_name(language_tag, in_locale, options)
    end
  end
end