require Cldr.LocaleDisplay

defmodule MyApp.Cldr do
  use Cldr,
    locales: :all, # ["en", "fr", "de", "zh"],
    default_locale: "en",
    providers: [Cldr.Territory, Cldr.LocaleDisplay, Cldr.Currency]
end
