defmodule Cldr.LocaleDisplayName.Test do
  use ExUnit.Case

  for [line, from, to] <- Cldr.LocaleDisplayNameGenerator.data(), !String.contains?(from, "-t-") do
    test "##{line} Locale #{inspect(from)} becomes #{inspect(to)}" do
      assert Cldr.LocaleDisplay.display_name(unquote(from), locale: "en", compound_locale: false) ==
        unquote(to)
    end
  end
end