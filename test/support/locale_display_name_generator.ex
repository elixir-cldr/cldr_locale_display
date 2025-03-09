defmodule Cldr.LocaleDisplayNameGenerator do
  def data do
    Path.join(__DIR__, "../data/locale_display_names.txt")
    |> Path.expand()
    |> File.read!()
    |> String.split("\n")
    |> Enum.with_index(1)
    |> Enum.reject(fn {elem, _index} -> String.starts_with?(elem, "#") end)
    |> Enum.reject(fn {elem, _index} -> elem == "" end)
    |> Enum.map(fn {l, index} ->
      l
      |> String.split(";")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&Cldr.Locale.locale_name_from_posix/1)
      |> List.insert_at(0, index)
    end)
    |> insert_locale_and_options()
    |> Enum.reverse()
  end

  def insert_locale_and_options(list) do
    {acc, _, _} =
      Enum.reduce(list, {[], nil, nil}, fn
        [line, locale, display], {acc, test_locale, language_display} ->
          {[[line, test_locale, language_display, locale, display] | acc], test_locale, language_display}

        [_line, option], {acc, locale, language_display} ->
          case String.split(option, "=") do
            ["@locale", locale] ->
              {acc, locale, language_display}
            ["@languageDisplay", language_display] ->
              {acc, locale, String.to_atom(language_display)}
          end
      end)
    acc
  end
end
