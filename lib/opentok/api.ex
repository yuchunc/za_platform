defmodule OpenTok.Api do

  alias OpenTok.Util

  @behaviour OpenTok.Behaviour

  @config Util.get_config()

  def request_session_id(headers) do
    {:ok, response} = HTTPoison.post(@config.endpoint <> "/session/create", [], headers)

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

  @doc """
  Monitor a Session
  """
  def get_session_state(session_id) do
    HTTPoison.get(@config.endpoint <> "/v2/project/" <> @config.key <> "/session/" <> session_id <> "/stream/")
  end
end
