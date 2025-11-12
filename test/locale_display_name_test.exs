defmodule Cldr.LocaleDisplayName.Test do
  use ExUnit.Case

  doctest Cldr.LocaleDisplay
  doctest MyApp.Cldr.LocaleDisplay

  # These tests have issues:
  # * 21,41 includes a field for a -u- tag that is invalid
  @invalid_test_results [41, 2530, 2527, 2528, 2531]
  @unexpected_root_locale_results [2517, 2512, 2525, 2518, 2515, 2513, 2526, 2514]

  # The test results for these are what would be generated with
  # language_display: :standard, but the test specifies language_tag: :dialect
  @wrong_language_display []

  @except_lines @invalid_test_results ++ @wrong_language_display ++ @unexpected_root_locale_results
  @locales [:en, :fr, :de, :it, :es, :zh, :"zh-Hans", :"zh-Hant", :ja]

  # Due to data errors in generated JSON
  @except_format_for_locales ["hi-Latn", "zh-Hans", "zh-Hant", "zh-Hans-fonipa"]

  for [line, locale, language_display, from, to] <- Cldr.LocaleDisplayNameGenerator.data(),
      line not in @except_lines, from not in @except_format_for_locales do
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
      line not in @except_lines && locale != :und && from not in @except_format_for_locales do
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

    assert Cldr.display_name(~l(zh-Hant)u) == "Traditional Chinese"
    assert Cldr.display_name(~l(zh-Hans)u) == "Simplified Chinese"
    assert Cldr.display_name(~l(zh-Hant)) == "Traditional Chinese (Taiwan)"
    assert Cldr.display_name(~l(zh-Hans)) == "Simplified Chinese (China)"
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

  test "prefer: :short when there is no :short display name" do
    assert "English (UK)" =
      Cldr.LocaleDisplay.display_name!("en_GB", locale: "en_GB", prefer: :short)

    assert "English (United Kingdom)" =
      Cldr.LocaleDisplay.display_name!("en_GB", locale: "en_GB", prefer: :standard)
  end
  
  test "returns error tuple for invalid locale" do
    result = Cldr.LocaleDisplay.display_name("xyz", prefer: :menu)
    assert match?({:error, _}, result)
  end

  test "display_name! raises on invalid locale" do
    assert_raise Cldr.InvalidLanguageError, fn ->
      Cldr.LocaleDisplay.display_name!("xyz", prefer: :menu)
    end
  end

  test "handles compound locale names with string keys" do
    # Kurdish Central (ckb) has compound structure with "core" and "extension" keys
    assert {:ok, name} = Cldr.LocaleDisplay.display_name("ckb", prefer: :menu, locale: :en)
    assert is_binary(name) and String.length(name) > 0
  end

  test "all locales can be displayed without crashing" do
    results =
      Cldr.all_locale_names()
      |> Enum.map(fn locale ->
        Cldr.LocaleDisplay.display_name(locale, compound_locale: false, prefer: :menu)
      end)

    # All should return either {:ok, name} or {:error, reason}, none should crash
    for result <- results do
      assert match?({:ok, _}, result) or match?({:error, _}, result)
    end
  end
end
