defmodule Cldr.DisplayName.NoDataError do
  @moduledoc """
  Exception raised when resolving a locale display name
  and there is no data in the requested locale (typically :und).
  """
  defexception [:message]

  def exception(message) do
    %__MODULE__{message: message}
  end
end
