defmodule ZaZaarWeb.LiveStreamController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def index(conn, _params) do
    stream_list = Streaming.get_channels()
    render(conn, "index.html", streams: stream_list)
  end

  def show(conn, %{"id" => streamer_id}) do
    render(conn, "show.html", streamer_id: streamer_id)
  end
end
