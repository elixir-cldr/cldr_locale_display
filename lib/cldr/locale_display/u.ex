defmodule Cldr.LocaleDisplay.U do
  @moduledoc false

  import Cldr.LocaleDisplay,
    only: [get_display_preference: 2, join_field_values: 2, replace_parens_with_brackets: 1]

  def display_name(locale, options) do
    {in_locale, _backend} = Cldr.locale_and_backend_from(options)
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
  def format_key_value(field, value, locale, in_locale, display_names, prefer) do
    if value_name = get(field, value, display_names) do
      replace_parens_with_brackets(value_name)
    else
      key_name = get_in(display_names, [:keys, field])
      display_value(field, key_name, value, locale, in_locale, display_names, prefer)
    end
  end

  # Returns the localised value for the key. If there is
  # no available key name then just return the value.

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

  defp display_value(key, key_name, value, locale, in_locale, display_names, prefer) do
    value_name =
      key
      |> get(key_name, value, locale, in_locale, display_names)
      |> Kernel.||(value)
      |> get_display_preference(prefer)
      |> :erlang.iolist_to_binary()
      |> replace_parens_with_brackets

    if key_name do
      display_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])
      Cldr.Substitution.substitute([key_name, value_name], display_pattern)
    else
      replace_parens_with_brackets(value_name)
    end
  end

  defp get(:rg, _key_name, value, _locale, in_locale, display_names) do
    get_territory(value, in_locale, display_names)
  end

  defp get(:sd, _key_name, value, _locale, in_locale, _display_names) do
    get_subdivision(value, in_locale, in_locale.backend)
  end

  defp get(:dx, _key_name, value, _locale, _in_locale, display_names) do
    case get_script(value, display_names) do
      nil -> nil
      script -> String.downcase(script)
    end
  end

  defp get(:timezone, _key_name, value, _locale, in_locale, _display_names) do
    get_timezone(value, in_locale)
  end

  defp get(:currency, _key_name, value, _locale, in_locale, _display_names) do
    get_currency(value, in_locale)
  end

  defp get(:col_reorder, _key_name, values, _locale, _in_locale, display_names) do
    Enum.map(values, fn value ->
      get_script(value, display_names) ||
        get_in(display_names, [:types, :col_reorder, value]) ||
        to_string(value)
    end)
    |> join_field_values(display_names)
  end

  defp get(_key, key_name, value, _locale, _in_locale, display_names) do
    get_in(display_names, [:types, key_name, value])
  end

  # The only field that key the key and the type
  # with different names
  defp get(:col_reorder, [value], display_names) do
    get_in(display_names, [:types, :col_reorder, value])
  end

  defp get(field, [value], display_names) do
    get_in(display_names, [:types, field, value])
  end

  defp get(field, value, display_names) do
    get_in(display_names, [:types, field, value])
  end

  # Territory code is an atom
  defp get_territory(territory, locale, display_names) do
    get_in(display_names, [:territory, territory]) ||
      get_subdivision(territory, locale, locale.backend)
  end

  defp get_script(script, display_names) do
    script = Cldr.Validity.Script.validate(script) |> elem(1)
    get_in(display_names, [:script, script])
  end

  defp get_subdivision(subdivision, locale, backend) do
    backend_module = Module.concat(backend, Territory)
    subdivision = Cldr.Validity.Subdivision.validate(subdivision) |> elem(1)
    backend_module.known_subdivisions(locale)[subdivision]
  end

  def get_timezone(zone, locale) do
    backend_module = Module.concat(locale.backend, LocaleDisplay)
    {:ok, zone_names} = backend_module.time_zone_names(locale)
    {:ok, territory_format} = backend_module.territory_format(locale)
    zone_parts = String.split(zone, "/")
    downcase_zone_parts = Enum.map(zone_parts, &String.downcase/1)

    case get_in(zone_names, downcase_zone_parts) do
      nil ->
        derive_zone_name(zone, zone_names, downcase_zone_parts, zone_parts, territory_format)

      zone_map ->
        case Map.get(zone_map, :exemplar_city) do
          nil ->
            derive_zone_name(zone, zone_names, downcase_zone_parts, zone_parts, territory_format)

          exemplar_city ->
            Cldr.Substitution.substitute([exemplar_city], territory_format)
        end
    end
  end

  # The time zone was not found in the time zone data. However, if the region exists
  # and there is only one other part, then form the time zone name by interpreting
  # the second part as a city name by replacing "_" with " ". This applies to zones like
  # "America/Los_Angeles", "America/New_York" and so on.

  defp derive_zone_name(zone, zone_names, downcase_zone_parts, zone_parts, territory_format) do
    with [downcase_region, _downcase_city] <- downcase_zone_parts do
      case Map.get(zone_names, downcase_region) do
        nil ->
          zone

        _region ->
          [_region, city] = zone_parts
          zone_name = String.replace(city, "_", " ")
          Cldr.Substitution.substitute([zone_name], territory_format)
      end
    else
      _other ->
        zone
    end
  end

  def get_currency(currency, locale) do
    case Cldr.Currency.currency_for_code(currency, locale.backend) do
      {:ok, currency} -> currency.symbol
      _other -> nil
    end
  end

  defimpl Cldr.DisplayName, for: Cldr.LanguageTag.U do
    def display_name(language_tag, options) do
      Cldr.LocaleDisplay.U.display_name(language_tag, options)
    end
  end
end
