defmodule OpenTok.Api do
  @behaviour OpenTok.Behaviour

  def create_session(headers, config) do
    HTTPoison.post(config.endpoint <> "/session/create", [], headers)
  end
end
