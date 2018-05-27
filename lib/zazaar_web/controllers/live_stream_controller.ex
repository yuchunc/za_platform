defmodule ZaZaarWeb.LiveStreamController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def index(conn, _params) do
    channels = Streaming.get_channels(snapshot: true)
    render(conn, "index.html", channels: channels)
  end

  def show(conn, %{"id" => streamer_id}) do
    render(conn, "show.html", streamer_id: streamer_id)
  end
end
