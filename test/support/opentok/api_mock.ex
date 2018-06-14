defmodule OpenTok.ApiMock do
  @behaviour OpenTok.Behaviour

  def request_session_id(_), do: {:ok, "fake"}

  def get_session_state(_, _), do: {:error, "fake"}

  def external_broadcast(_, _, _), do: {:error, "fake"}
end
