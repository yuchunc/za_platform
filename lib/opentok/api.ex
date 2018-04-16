defmodule OpenTok.Api do
  @behaviour OpenTok.Behaviour

  def request_session_id(headers, config) do
    {:ok, response} = HTTPoison.post(config.endpoint <> "/session/create", [], headers)

    case response.status_code do
      403 ->
        {:error, "Authentication failed while creating a session."}
      sc when sc in 200..300 ->
        {:ok, [%{"session_id" => session_id}]} = Poison.decode(response.body)
        {:ok, session_id}
      sc ->
        {:error, "Failed to create session. Response code: #{sc}"}
    end
  end
end
