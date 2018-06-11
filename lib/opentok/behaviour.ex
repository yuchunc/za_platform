defmodule OpenTok.Behaviour do
  @type headers :: HTTPoison.Base.headers()
  @type response :: {:ok, String.t()}
  @type ot_state_response ::
          {:ok, :active} | {:ok, :inactive} | {:ok, :nohost} | {:error, String.t()}

  @callback request_session_id(headers) :: response

  @callback get_session_state(String.t(), headers) :: ot_state_response

  @callback external_broadcast(String.t(), headers, [map]) ::
              :ok | {:error, :noclient} | {:error, String.t()}
end
