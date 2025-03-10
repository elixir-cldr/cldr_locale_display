defmodule Cldr.LocaleDisplayName.Test do
  use ExUnit.Case

  doctest Cldr.LocaleDisplay
  doctest MyApp.Cldr.LocaleDisplay

  # These tests have issues:
  # * 1566, 1569, 1686, 1699 seem to have the incorrect test result in the data
  # * 344, 345 appear to have the wrong timezone returned
  # * 21,41 includes a field for a -u- tag that is invalid
  @invalid_test_results [21, 41, 344, 345, 1556, 1569, 1686, 1699]

  # These have test results with [] but I think they should remain ()
  # since there are no subtags or extensions.
  @results_should_be_parens [
    396,
    474,
    500,
    786,
    864,
    942,
    1124,
    1203,
    1254,
    1358,
    1384,
    1538,
    1928,
    2008,
    2188,
    2214,
    2242,
    2254,
    2268,
    2294,
    2500,
    2554,
    2580,
    2684,
    2708,
    2942,
    2968,
    2994,
    3020,
    3022,
    3126,
    3152,
    3178
  ]

  # The test results for these are what would be generated with
  # language_display: :standard, but the test specifies language_tag: :dialect
  @wrong_language_display [
    2370,
    2374,
    2375,
    2371
  ]

  @except_lines @invalid_test_results ++ @results_should_be_parens ++ @wrong_language_display
  @locales [:en, :fr, :de, :it, :es, :zh, :"zh-Hans", :"zh-Hant", :ja]

  for [line, locale, language_display, from, to] <- Cldr.LocaleDisplayNameGenerator.data(),
      line not in @except_lines do
    test "##{line} Locale #{inspect(from)} becomes #{inspect(to)} in locale #{inspect(locale)}" do
      assert Cldr.LocaleDisplay.display_name!(unquote(from),
               locale: unquote(locale),
               language_display: unquote(language_display)
             ) ==
               unquote(to)
    end
  end

  for [line, _locale, language_display, from, _to] <- Cldr.LocaleDisplayNameGenerator.data(),
      locale <- @locales,
      line not in @except_lines && locale != :und do
    test "##{line} Language tag #{inspect(from)} in locale #{inspect(locale)} renders" do
      assert Cldr.LocaleDisplay.display_name!(unquote(from),
               locale: unquote(locale),
               language_display: unquote(language_display)
             )
    end
  end

  test "Transform and extensions" do
    locale_string = "fr-z-zz-zzz-v-vv-vvv-t-ru-Cyrl-s-ss-sss-a-aa-aaa-x-u-x"

    assert Cldr.LocaleDisplay.display_name!(locale_string, locale: "en") ==
             "French (Transform: Russian [Cyrillic], a: aa-aaa, s: ss-sss, v: vv-vvv, x: u-x, z: zz-zzz)"
  end

  test "Cldr.DisplayName protocol" do
    import Cldr.LanguageTag.Sigil

    assert Cldr.display_name(~l(en)u) == "English"
    assert Cldr.display_name(~l(zh-Hans)u, language_display: :dialect) == "Simplified Chinese"
    assert Cldr.display_name(~l(zh-Hant)u, language_display: :dialect) == "Traditional Chinese"

    assert Cldr.display_name(~l(zh-Hant), language_display: :dialect) ==
             "Traditional Chinese (Taiwan)"

    assert Cldr.display_name(~l(zh-Hans), language_display: :dialect) ==
             "Simplified Chinese (China)"

    assert Cldr.display_name(~l(zh-Hant)u) == "Chinese (Traditional)"
    assert Cldr.display_name(~l(zh-Hans)u) == "Chinese (Simplified)"
    assert Cldr.display_name(~l(zh-Hant)) == "Chinese (Traditional, Taiwan)"
    assert Cldr.display_name(~l(zh-Hans)) == "Chinese (Simplified, China)"
  end

  test "More complex language tags" do
    import Cldr.LanguageTag.Sigil

    assert Cldr.display_name(~l"fr-CA-u-ca-gregory-nu-arab-cu-usd-cf-account-ms-uksystem-t-hi"u,
             locale: "zh-Hant"
           )

    assert Cldr.display_name(
             ~l"fr-CA-u-ca-gregory-nu-arab-cu-usd-cf-account-ms-uksystem-t-hi-h0-hybrid"u,
             locale: "zh-Hant"
           )

    assert Cldr.display_name(~l"fr-CA-u-ca-gregory-nu-arab-cu-usd-cf-account-ms-uksystem-t-hi"u,
             locale: "zh-Hans"
           )

    assert Cldr.display_name(
             ~l"fr-CA-u-ca-gregory-nu-arab-cu-usd-cf-account-ms-uksystem-t-hi-h0-hybrid"u,
             locale: "zh-Hans"
           )
  end
