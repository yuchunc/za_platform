defmodule OpenTok.Behaviour do

  @type headers :: HTTPoison.Base.headers
  @type response ::
    {:ok, HTTPoison.Response.t | HTTPoison.AsyncResponse.t} |
    {:error, HTTPoison.Error.t}

  @callback create_session(headers, map) :: response
end
