defmodule OpenTok.Behaviour do
  @type headers :: HTTPoison.Base.headers()
  @type response :: :ok | {:ok, atom()} | {:ok, String.t()} | {:error, atom} | {:error, String.t()}

  @callback request_session_id(headers) :: response

  @callback get_session_state(String.t(), headers) :: response

  @callback external_broadcast(String.t(), headers, [map]) :: response
end
