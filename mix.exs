defmodule Cldr.LocaleDisplay.MixProject do
  use Mix.Project

  @version "1.3.1"

  def project do
    [
      app: :ex_cldr_locale_display,
      version: @version,
      elixir: "~> 1.10",
      name: "Cldr Locale Display",
      description: description(),
      source_url: "https://github.com/elixir-cldr/cldr_locale_display",
      docs: docs(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      package: package(),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(inets jason mix)a
      ]
    ]
  end

  defp description do
    """
    Locale display name presentation for Common Locale Data Repository (CLDR)
    locales.
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_cldr, "~> 2.26"},
      {:ex_cldr_currencies, "~> 2.12"},
      {:ex_cldr_territories, "~> 2.4"},
      {:jason, "~> 1.0", optional: true},
      {:ex_doc, "~> 0.18", onley: [:dev, :release], runtime: false, optional: true},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:benchee, "~> 1.0", only: :dev, optional: true}
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache-2.0"],
      links: links(),
      files: [
        "lib",
        "config",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*"
      ]
    ]
  end

  def docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md", "CHANGELOG.md", "LICENSE.md"],
      logo: "logo.png",
      skip_undefined_reference_warnings_on: ["changelog", "CHANGELOG.md"]
    ]
  end

  def links do
    %{
      "GitHub" => "https://github.com/kipcole9/cldr_locale_display",
      "Readme" => "https://github.com/kipcole9/cldr_locale_display/blob/v#{@version}/README.md",
      "Changelog" =>
        "https://github.com/kipcole9/cldr_locale_display/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(:dev), do: ["lib", "mix"]
  defp elixirc_paths(_), do: ["lib"]
end
