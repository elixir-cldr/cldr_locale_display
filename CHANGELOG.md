# Changelog

Note that as of Cldr Locale Display version 1.5.0, Elixir 1.12 or later is required.

## Cldr Locale Display v1.6.0

This is the changelog for Cldr Locale Display v1.6.0 released on March 18th, 2025.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Enhancements

* Update to [CLDR 47](https://cldr.unicode.org/downloads/cldr-47) data.

## Cldr Locale Display v1.5.0

This is the changelog for Cldr Locale Display v1.5.0 released on June 22nd, 2024.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Enhancements

* Require Elixir 1.12 or later

* Updated test data to latest CLDR version.

## Cldr Locale Display v1.4.1

This is the changelog for Cldr Locale Display v1.4.1 released on January 2nd, 2024.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Bug Fixes

* Fix `ex_doc` dependency configuration. Thanks to @szymon-jez for the PR.

* Fix project links in `mix.exs`. Thanks to @szymon-jez and @petrus-jvrensburg for the PRs.

## Cldr Locale Display v1.4.0

This is the changelog for Cldr Locale Display v1.4.0 released on April 28th, 2023.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Bug Fixes

* Fixes an exception that was being raised with the formatting locale has no display name data. This is typically the `:und` locale. An error is returned instead.

## Cldr Locale Display v1.3.1

This is the changelog for Cldr Locale Display v1.3.0 released on August 28th, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Bug Fixes

* Fix the typespecs and documentation `Cldr.LocaleDisplay.display_name/2` supports locale names as atoms, strings or language tags. Thanks to @japplegame for the PR. Closes #3.

## Cldr Locale Display v1.3.0

This is the changelog for Cldr Locale Display v1.3.0 released on February 23rd, 2022.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Enhancements

* Updates to [ex_cldr version 2.26.0](https://hex.pm/packages/ex_cldr/2.26.0) which uses atoms for locale names and rbnf locale names. This is consistent with out elements of `t:Cldr.LanguageTag` where atoms are used where the cardinality of the data is fixed and relatively small and strings where the data is free format.

## Cldr Locale Display v1.2.0

This is the changelog for Cldr Locale Display v1.2.0 released on October 28th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Enhancements

* Updated to `ex_cldr 2.24` which implements [CLDR 40](https://cldr.unicode.org/index/downloads/cldr-40) data.

## Cldr Locale Display v1.2.0-rc.0

This is the changelog for Cldr Locale Display v1.2.0-rc.0 released on October 20th, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Enhancements

* Updated to `ex_cldr 2.24` which implements [CLDR 40](https://cldr.unicode.org/index/downloads/cldr-40) data.

## Cldr Locale Display v1.1.2

This is the changelog for Cldr Locale Display v1.1.2 released on July 3rd, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Bug Fixes

* Fix bug where not all locales have display names for the key `t` or the type `h0`

* Fix bug where the locale into which we are localising is valid but not configured

## Cldr Locale Display v1.1.1

This is the changelog for Cldr Locale Display v1.1.1 released on July 3rd, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Bug Fixes

* Actual fixes for the issue when the compound name includes the script (like zh-Hant).

## Cldr Locale Display v1.1.0

This is the changelog for Cldr Locale Display v1.1.0 released on July 3rd, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Bug Fixes

* Correct an issue when the compound name includes the script (like zh-Hant).

### Enhancements

* Add `display_names/{1,2}` to backend modules.

## Cldr Locale Display v1.0.0

This is the changelog for Cldr Locale Display v1.0.0 released on July 1st, 2021.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_locale_display/tags)

### Enhancements

This is the first release of `ex_cldr_locale_display` which implements the [CLDR locale display name algorithm](https://unicode-org.github.io/cldr/ldml/tr35-general.html#locale_display_name_algorithm).


