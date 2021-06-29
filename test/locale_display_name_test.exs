defmodule Cldr.LocaleDisplayName.Test do
  use ExUnit.Case

  import Cldr.LanguageTag.Sigil

  for [line, from, to] <- Cldr.LocaleDisplayNameGenerator.data() do
    test "##{line} Locale #{inspect(from)} becomes #{inspect(to)}" do
      assert Cldr.display_name(~l(unquote(from))) == unquote(to)
    end
  end
end