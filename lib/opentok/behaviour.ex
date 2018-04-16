defmodule OpenTok.Behaviour do

  @type headers :: HTTPoison.Base.headers
  @type response :: {:ok, String.t} | {:ok, String.t}

  @callback request_session_id(headers, map()) :: response
end
