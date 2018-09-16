defmodule ZaZaarWeb.LiveStreamController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def index(conn, _params) do
    with channels0 <- Streaming.get_channels(snapshot: true),
         streamer_ids <- Enum.map(channels0, & &1.streamer_id),
         users <- Account.get_user(streamer_ids),
         channels1 <- append_streamer(channels0, users) do
      render(conn, "index.html", channels: channels1)
    end
  end

  def show(conn, %{"id" => streamer_id}) do
    streamer = Account.get_user(streamer_id)
    render(conn, "show.html", streamer: streamer)
  end

  defp append_streamer(channels, users) do
    Enum.map(channels, fn channel ->
      user = Enum.find(users, &(&1.id == channel.streamer_id))
      Map.put_new(channel, :streamer, user)
    end)
  end
end
