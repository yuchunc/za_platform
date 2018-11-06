defmodule Facebook.GraphApi do
  alias Facebook.Config

  def request() do
    {:ok, %{status_code: sc, body: body}} = HTTPoison.get(Config.graph_url())

    {sc, Poison.decode!(body)}
  end
end
