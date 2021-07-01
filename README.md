# Cldr Locale Display

Presents language tags in a presnetation format suitable for UI applications.
It implements the [CLDR locale display name algorithm](https://unicode-org.github.io/cldr/ldml/tr35-general.html#locale_display_name_algorithm).

## Installation

The package can be installed by adding `ex_cldr_locale_display` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_locale_display, "~> 1.0"}
  ]
end
```

## Examples

```elixir
iex> Cldr.LocaleDisplay.display_name "en"
{:ok, "English"}

iex> Cldr.LocaleDisplay.display_name "en-US"
{:ok, "American English"}

iex> Cldr.LocaleDisplay.display_name "en-US", compound_locale: false
{:ok, "English (United States)"}

iex> Cldr.LocaleDisplay.display_name "en-US-u-ca-gregory-cu-aud"
{:ok, "American English (Gregorian Calendar, Currency: A$)"}

iex> Cldr.LocaleDisplay.display_name "en-US-u-ca-gregory-cu-aud", locale: "fr"
{:ok, "anglais américain (calendrier grégorien, devise : A$)"}

iex> Cldr.LocaleDisplay.display_name "nl-BE"
{:ok, "Flemish"}

iex> Cldr.LocaleDisplay.display_name "nl-BE", compound_locale: false
{:ok, "Dutch (Belgium)"}
```