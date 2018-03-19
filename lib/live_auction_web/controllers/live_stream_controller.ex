defmodule LiveAuctionWeb.LiveStreamController do
  use LiveAuctionWeb, :controller

  def show(conn, params) do
    with %{"id" => streamer_id} <- params,
         stream <- Streaming.current_stream(streamer_id)
    do
      render conn, "show.html", stream_id: streamer_id, stream: stream
    end
  end
end
