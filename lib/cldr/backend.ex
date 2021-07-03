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

        @moduledoc """
        Manages the display name data for language tags
        and presents a public API for rendering
        display names for locales.

        """

        @doc """
        Returns a localised display name for a
        locale.

        UI applications often have a requirement
        to present locale choices to an end user.

        This function takes a `t.Cldr.LanguageTag`
        and using the [CLDR locale display name algorithm](https://unicode-org.github.io/cldr/ldml/tr35-general.html#locale_display_name_algorithm)
        produces a string suitable for presentation.

        ## Arguments

        * `language_tag` is any `t:Cldr.LanguageTag` or
          a binary locale name.

        * `options` is a keyword list of options.

        ## Options

        * `:compound_locale` is a boolean indicating
          if the combination of language, script and territory
          should be used to resolve a language name.
          The default is `true`.

        * `:prefer` signals the preferred name for
          a subtag when there are alternatives.
          The default is `:default`. Few subtags
          provide alternative renderings. Some of
          the alternative preferences are`:short`,
          `:long`, `:menu` and `:variant`.

        * `:locale` is a `t:Cldr.LanguageTag` or any valid
          locale name returned by `Cldr.known_locale_names/1`.

        ## Returns

        * `{:ok, string}` representating a name
          suitable for presentation purposes or

        * `{:error, {exception, reason}}`

        ## Examples

            iex> #{inspect(__MODULE__)}.display_name "en"
            {:ok, "English"}

            iex> #{inspect(__MODULE__)}.display_name "en-US"
            {:ok, "American English"}

            iex> #{inspect(__MODULE__)}.display_name "en-US", compound_locale: false
            {:ok, "English (United States)"}

            iex> #{inspect(__MODULE__)}.display_name "en-US-u-ca-gregory-cu-aud"
            {:ok, "American English (Gregorian Calendar, Currency: A$)"}

            iex> #{inspect(__MODULE__)}.display_name "en-US-u-ca-gregory-cu-aud", locale: "fr"
            {:ok, "anglais américain (calendrier grégorien, devise : A$)"}

            iex> #{inspect(__MODULE__)}.display_name "nl-BE"
            {:ok, "Flemish"}

            iex> #{inspect(__MODULE__)}.display_name "nl-BE", compound_locale: false
            {:ok, "Dutch (Belgium)"}

        """
        @doc since: "1.1.0"

        @spec display_name(
                Cldr.Locale.locale_name() | Cldr.LanguageTag.t(),
                Cldr.LocaleDisplay.display_options()
              ) ::
                {:ok, String.t()} | {:error, {module(), String.t()}}

        def display_name(language_tag, options \\ []) do
          options = Keyword.put(options, :backend, unquote(backend))
          Cldr.LocaleDisplay.display_name(language_tag, options)
        end

        @doc """
        Returns a localised display name for a
        locale.

        UI applications often have a requirement
        to present locale choices to an end user.

        This function takes a `t.Cldr.LanguageTag`
        and using the [CLDR locale display name algorithm](https://unicode-org.github.io/cldr/ldml/tr35-general.html#locale_display_name_algorithm)
        produces a string suitable for presentation.

        ## Arguments

        * `language_tag` is any `t:Cldr.LanguageTag` or
          a binary locale name.

        * `options` is a keyword list of options.

        ## Options

        * `:compound_locale` is a boolean indicating
          if the combination of language, script and territory
          should be used to resolve a language name.
          The default is `true`.

        * `:prefer` signals the preferred name for
          a subtag when there are alternatives.
          The default is `:default`. Few subtags
          provide alternative renderings. Some of
          the alternative preferences are`:short`,
          `:long`, `:menu` and `:variant`.

        * `:locale` is a `t:Cldr.LanguageTag` or any valid
          locale name returned by `Cldr.known_locale_names/1`.

        * `:backend` is any module that includes `use Cldr` and therefore
          is a `Cldr` backend module. The default is `Cldr.default_backend!/0`.

        ## Returns

        * a string representation of the language tag
          suitable for presentation purposes or

        * raises an exception.

        ## Examples

            iex> #{inspect(__MODULE__)}.display_name! "en"
            "English"

            iex> #{inspect(__MODULE__)}.display_name! "en-US"
            "American English"

            iex> #{inspect(__MODULE__)}.display_name! "en-US", compound_locale: false
            "English (United States)"

            iex> #{inspect(__MODULE__)}.display_name! "en-US-u-ca-gregory-cu-aud"
            "American English (Gregorian Calendar, Currency: A$)"

            iex> #{inspect(__MODULE__)}.display_name! "en-US-u-ca-gregory-cu-aud", locale: "fr"
            "anglais américain (calendrier grégorien, devise : A$)"

        """
        @doc since: "1.1.0"

        @spec display_name!(
                Cldr.Locale.locale_name() | Cldr.LanguageTag.t(),
                Cldr.LocaleDisplay.display_options()
              ) ::
                String.t() | no_return()

        def display_name!(language_tag, options \\ []) do
          options = Keyword.put(options, :backend, unquote(backend))
          Cldr.LocaleDisplay.display_name!(language_tag, options)
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
        @doc since: "1.0.0"

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
        @doc since: "1.0.0"

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
