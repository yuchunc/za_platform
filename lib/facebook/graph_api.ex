defmodule Facebook.GraphApi do
  alias Facebook.Config

  def request(path) do
    {:ok, %{status_code: sc, body: body}} =
      HTTPoison.get(Config.graph_url() <> path <> access_token)

    {sc, Poison.decode!(body)}
  end

  def access_token do
    "?access_token=" <> Config.access_token()
  end
end
