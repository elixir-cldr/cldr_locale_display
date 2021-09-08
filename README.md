# Cldr Locale Display
![Build Status](http://sweatbox.noexpectations.com.au:8080/buildStatus/icon?job=cldr_locale_display)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_cldr_locale_display.svg)](https://hex.pm/packages/ex_cldr_locale_display)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_cldr_locale_display.svg?)](https://hex.pm/packages/ex_cldr_locale_display)
[![Hex.pm](https://img.shields.io/hexpm/dt/ex_cldr_locale_display.svg?)](https://hex.pm/packages/ex_cldr_locale_display)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_cldr_locale_display.svg)](https://hex.pm/packages/ex_cldr_locale_display)

Presents language tags in a presentation format suitable for UI applications.
It implements the [CLDR locale display name algorithm](https://unicode-org.github.io/cldr/ldml/tr35-general.html#locale_display_name_algorithm).

## Installation

The package can be installed by adding `ex_cldr_locale_display` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_cldr_locale_display, "~> 1.1"}
  ]
end
```

## Configuration

In keeping with all `ex_cldr`-based libraries, a backend module is required which hosts the display data used to produce locale display names. A simple example is given here. For full information on configuring a backend module, see the [configuration section](https://hexdocs.pm/ex_cldr/readme.html#configuration) for [ex_cldr](https://hex.pm/packages/ex_cldr).

```elixir
defmodule MyApp.Cldr do
  use Cldr,
    locales: ["en", "de", "th", "fr", "fr-CH", "zh", "ar"],
    default_locale: "en",
    providers: [Cldr.Territory, Cldr.LocaleDisplay, Cldr.Currency]
end
```
## Examples

THe follow examples require that a `:default_backend` be set in `config.exs` for the `:ex_cldr` configuration key. See the [configuration section](https://hexdocs.pm/ex_cldr/readme.html#configuration) for [ex_cldr](https://hex.pm/packages/ex_cldr) for more information.

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

### Rendering a list of locales in their own languages

When presenting a list of locales to a user for selection it may be appropriate to present those display name in the language of the locale. The package [ex_cldr_html](https://hex.pm/packages/ex_cldr_html) includes a helper function for this but a simple approach is also possible.

The following snippet renders the list of known locales as display names in each locales own language. It uses a backend module configuration noted above.

```elixir
iex> MyApp.Cldr.known_locale_names()
.... |> Enum.map(&{&1, MyApp.Cldr.LocaleDisplay.display_name!(&1, locale: &1, prefer: :menu)})
.... |> Enum.sort
[
  {"ar", "العربية"},
  {"de", "Deutsch"},
  {"en", "English"},
  {"fr", "français"},
  {"fr-CH", "français suisse"},
  {"th", "ไทย"},
  {"zh-Hans", "简体中文"},
  {"zh-Hant", "繁體中文"}
]

# In some cases it is preferred to not use compound
# locale names. Note the different rendering for the
# locale fr-CH
iex> MyApp.Cldr.known_locale_names
.... |> Enum.map(&{&1, MyApp.Cldr.LocaleDisplay.display_name!(&1, locale: &1, compound_locale: false, prefer: :menu)})
.... |> Enum.sort
[
  {"ar", "العربية"},
  {"de", "Deutsch"},
  {"en", "English"},
  {"fr", "français"},
  {"fr-CH", "français (Suisse)"},
  {"th", "ไทย"},
  {"zh-Hans", "简体中文（简体）"},
  {"zh-Hant", "繁體中文（繁體）"}
]
```
