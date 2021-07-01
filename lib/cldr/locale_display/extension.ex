defmodule Cldr.LocaleDisplay.Extension do
  @moduledoc """


  """
  import Cldr.LocaleDisplay.U, only: [join_field_values: 2]

  # locale_display_pattern: %{
  #   locale_key_type_pattern: [0, ": ", 1],
  #   locale_pattern: [0, " (", 1, ")"],
  #   locale_separator: [0, ", ", 1]
  # }

  def display_name(extensions, options) do
    {in_locale, _backend} = Cldr.locale_and_backend_from(options)
    module = Module.concat(in_locale.backend, :LocaleDisplay)
    {:ok, display_names} = module.display_names(in_locale)
    key_type_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])

    extensions
    |> Enum.sort()
    |> Enum.map(fn {extension, key_value_pairs} ->
      IO.inspect key_value_pairs
      value_names =
        key_value_pairs
        |> Enum.chunk_every(2)
        |> Enum.map(fn [key, value] -> "#{key}-#{value}" end)
        |> join_field_values(display_names)

      Cldr.Substitution.substitute([extension, value_names], key_type_pattern)
    end)
    |> join_field_values(display_names)
  end
end