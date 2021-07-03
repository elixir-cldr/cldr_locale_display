# Changelog

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


