defmodule Cldr.LocaleDisplay.Backend do
  @moduledoc false

  def define_locale_display_module(config) do
    require Cldr
    require Cldr.Config

    module = inspect(__MODULE__)
    backend = config.backend
    config = Macro.escape(config)

    quote location: :keep, bind_quoted: [module: module, backend: backend, config: config] do
      defmodule LocaleDisplay do
        unless Cldr.Config.include_module_docs?(config.generate_docs) do
          @moduledoc false
        end

        @doc """
        Returns the localised display names data
        for a locale name.

        ## Arguments

        * `locale` is any language tag returned by
          `#{inspect(__MODULE__)}.new/1`
          or a locale name in the list returned by
          `#{inspect(config.backend)}.known_locale_names/0`

        ## Returns

        * A map of locale display names

        ## Examples

            => #{inspect(__MODULE__)}.display_names("en")

        """
        @doc since: "0.1.0"

        @spec display_names(Cldr.LanguageTag.t() | Cldr.Locale.locale_name()) ::
                {:ok, map()} | {:error, {module(), String.t()}}

        def display_names(locale)

        @doc """
        Returns the localised time zone names data
        for a locale name.

        ## Arguments

        * `locale` is any language tag returned by
          `#{inspect(__MODULE__)}.new/1`
          or a locale name in the list returned by
          `#{inspect(config.backend)}.known_locale_names/0`

        ## Returns

        * A map of locale time zone names

        ## Examples

            => #{inspect(__MODULE__)}.time_zone_names("en")

        """
        @doc since: "0.1.0"

        @spec time_zone_names(Cldr.LanguageTag.t() | Cldr.Locale.locale_name()) ::
                {:ok, map()} | {:error, {module(), String.t()}}

        def time_zone_names(locale)

        @doc false
        def territory_format(locale)

        @doc false
        def territory_daylight_format(locale)

        @doc false
        def territory_standard_format(locale)

        for locale_name <- Cldr.Config.known_locale_names(config) do
          locale = Cldr.Config.get_locale(locale_name, config)
          locale_display_names = locale.locale_display_names
          time_zone = locale.dates.time_zone_names
          time_zone_names = time_zone.zone

          region_format = time_zone.region_format
          daylight_format = time_zone.region_format_type_daylight
          standard_format = time_zone.region_format_type_standard

          def display_names(unquote(locale_name)) do
            {:ok, unquote(Macro.escape(locale_display_names))}
          end

          def time_zone_names(unquote(locale_name)) do
            {:ok, unquote(Macro.escape(time_zone_names))}
          end

          def territory_format(unquote(locale_name)) do
            {:ok, unquote(region_format)}
          end

          def territory_daylight_format(unquote(locale_name)) do
            {:ok, unquote(daylight_format)}
          end

          def territory_standard_format(unquote(locale_name)) do
            {:ok, unquote(standard_format)}
          end
        end

        def display_names(%LanguageTag{} = locale) do
          display_names(locale.cldr_locale_name)
        end

        def display_names(locale) do
          {:error, Cldr.Locale.locale_error(locale)}
        end

        def time_zone_names(%LanguageTag{} = locale) do
          time_zone_names(locale.cldr_locale_name)
        end

        def time_zone_names(locale) do
          {:error, Cldr.Locale.locale_error(locale)}
        end

        def territory_format(%LanguageTag{} = locale) do
          territory_format(locale.cldr_locale_name)
        end

        def territory_daylight_format(%LanguageTag{} = locale) do
          territory_daylight_format(locale.cldr_locale_name)
        end

        def territory_standard_format(%LanguageTag{} = locale) do
          territory_standard_format(locale.cldr_locale_name)
        end

        def territory_format(locale) do
          {:error, Cldr.Locale.locale_error(locale)}
        end

        def territory_daylight_format(locale) do
          {:error, Cldr.Locale.locale_error(locale)}
        end

        def territory_standard_format(locale) do
          {:error, Cldr.Locale.locale_error(locale)}
        end
      end
    end
  end
end
