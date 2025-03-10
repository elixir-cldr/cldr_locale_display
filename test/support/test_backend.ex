require Cldr.LocaleDisplay

defmodule MyApp.Cldr do
  use Cldr,
    # ["en", "fr", "de", "zh"],
    locales: :all,
    default_locale: "en",
    providers: [Cldr.Territory, Cldr.LocaleDisplay, Cldr.Currency]
end
