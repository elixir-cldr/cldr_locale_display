defmodule Cldr.LocaleDisplayName.Test do
  use ExUnit.Case

  doctest Cldr.LocaleDisplay

  # Three tests have issues:
  # * 308 and 309 appear to have the wrong timezone returned
  # * 31 includes a field for a -u- tag that is invalid

  @except_lines [31, 308, 309]

  for [line, from, to] <- Cldr.LocaleDisplayNameGenerator.data(), line not in @except_lines do
    test "##{line} Locale #{inspect(from)} becomes #{inspect(to)}" do
      assert Cldr.LocaleDisplay.display_name!(unquote(from), locale: "en", compound_locale: false) ==
        unquote(to)
    end
  end

  test "Transform and extensions" do
    locale_string = "fr-z-zz-zzz-v-vv-vvv-t-ru-Cyrl-s-ss-sss-a-aa-aaa-x-u-x"

    assert Cldr.LocaleDisplay.display_name!(locale_string, locale: "en", compound_locale: false) ==
      "French (Transform: Russian [Cyrillic], a: aa-aaa, s: ss-sss, v: vv-vvv, x: u-x, z: zz-zzz)"
  end

  test "Cldr.DisplayName protocol" do
    import Cldr.LanguageTag.Sigil

    assert Cldr.display_name(~l(en)u) == "English"
  end
end