defmodule LiveAuctionWeb.LiveStreamController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  def index(conn, _params) do
    stream_list = Streaming.get_streams
    render(conn, "index.html", streams: stream_list)
  end

  def show(conn, %{"id" => streamer_id}) do
    with %Stream{} = stream <- Streaming.current_stream_for(streamer_id),
         viewer <- current_resource(conn),
         {:ok, key, token} <- OpenTok.generate_token(stream.ot_session_id, :subscriber, viewer[:id]),
         opentok_params <- %{session_id: stream.ot_session_id, token: token, key: key}
    do
      render(conn, "show.html", stream_id: streamer_id, opentok_params: opentok_params)
    end
  end
end
