if Mix.env() in [:dev] do
  require Cldr.LocaleDisplay

  defmodule MyApp.Cldr do
    use Cldr,
      locales: ["en", "de", "th", "fr", "fr-CH", "zh-Hans", "zh-Hant", "ar", "he"],
      default_locale: "en",
      providers: [Cldr.Territory, Cldr.LocaleDisplay, Cldr.Currency]
  end
end
