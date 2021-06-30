require Cldr.LocaleDisplay

defmodule MyApp.Cldr do
  use Cldr,
    locales: ["en", "fr", "de", "zh"],
    default_locale: "en",
    providers: [Cldr.Territory, Cldr.LocaleDisplay]
end

