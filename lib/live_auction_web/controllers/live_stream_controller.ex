defmodule LiveAuctionWeb.LiveStreamController do
  use LiveAuctionWeb, :controller

  def index(conn, _params) do
    stream_list = Streaming.get_streams
    render(conn, "index.html", streams: stream_list)
  end

  def show(conn, %{"id" => streamer_id}) do
    with stream <- Streaming.current_stream_for(streamer_id),
         {:ok, token} <- OpenTok.generate_token(stream.ot_session_id, :subscriber, "subscriber1"),
         ot_config <- OpenTok.Util.get_config,
         opentok_params <- %{session_id: stream.ot_session_id, token: token, config: ot_config}
    do
      render conn, "show.html", stream_id: streamer_id, opentok_params: opentok_params
    end
  end
end
