defmodule Facebook.GraphApiMock do
  @behaviour Facebook.ApiBehaviour

  def request(_), do: {:error, "fake"}
end
