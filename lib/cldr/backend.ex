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
        @doc since: "2.23.0"

        @spec display_names(Cldr.LanguageTag.t() | Cldr.Locale.locale_name()) ::
                {:ok, map()} | {:error, {module(), String.t()}}

        def display_names(locale)

        for locale_name <- Cldr.Config.known_locale_names(config) do
          locale_display_names = Cldr.Config.get_locale(locale_name, config).locale_display_names

          def display_names(unquote(locale_name)) do
            {:ok, unquote(Macro.escape(locale_display_names))}
          end
        end

        def display_names(%LanguageTag{} = locale) do
          display_names(locale.cldr_locale_name)
        end

        def display_names(locale) do
          {:error, Cldr.Locale.locale_error(locale)}
        end

      end
    end
  end
end
