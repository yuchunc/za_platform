defmodule LiveAuctionWeb.StreamingController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  def show(conn, _params) do
    with %User{} = streamer <- current_resource(conn),
         {:ok, stream} <- Streaming.new_session(streamer.id),
         {:ok, key, token} <- OpenTok.generate_token(stream.ot_session_id, :publisher, streamer.id),
         opentok_params <- %{session_id: stream.ot_session_id, token: token, key: key}
    do
      render(conn, "show.html", opentok_params: opentok_params)
    end
  end
end
