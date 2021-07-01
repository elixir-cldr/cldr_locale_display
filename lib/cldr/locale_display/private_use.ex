defmodule Cldr.LocaleDisplay.PrivateUse do
  @moduledoc """


  """
  import Cldr.LocaleDisplay, only: [join_field_values: 2]

  def display_name(private_use, options) do
    {in_locale, _backend} = Cldr.locale_and_backend_from(options)
    module = Module.concat(in_locale.backend, :LocaleDisplay)
    {:ok, display_names} = module.display_names(in_locale)
    key_type_pattern = get_in(display_names, [:locale_display_pattern, :locale_key_type_pattern])

    private_use
    |> Enum.sort()
    |> Enum.map(fn {key, values} ->
      value_names = join_field_values(values, display_names)
      Cldr.Substitution.substitute([key, value_names], key_type_pattern)
    end)
  end
end