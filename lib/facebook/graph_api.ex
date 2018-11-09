defmodule Facebook.GraphApi do
  @behaviour Facebook.ApiBehaviour

  alias Facebook.Config

  def request(path) do
    {:ok, %{status_code: sc, body: body}} =
      HTTPoison.get(Config.graph_url() <> path <> access_token())

    {sc, Poison.decode!(body)}
  end

  defp access_token do
    "?access_token=" <> Config.access_token()
  end
end
