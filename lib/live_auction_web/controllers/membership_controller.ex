defmodule LiveAuctionWeb.MembershipController do
  use LiveAuctionWeb, :controller

  def show(conn, %{"id" => streamer_id}) do
    with stream <- Streaming.current_stream(streamer_id),
         ot_config <- Application.get_env(:live_auction, OpenTok) |> Map.new,
         {:ok, token} <- OpenTok.generate_token(stream.ot_session_id, :publisher, "publisher1"),
         opentok_params <- %{session_id: stream.ot_session_id, token: token, config: ot_config}
    do
      render(conn, "dashboard.html", opentok_params: opentok_params)
    end
  end
end
