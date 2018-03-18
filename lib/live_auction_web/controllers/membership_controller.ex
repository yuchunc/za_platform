defmodule LiveAuctionWeb.MembershipController do
  use LiveAuctionWeb, :controller

  def show(conn, _) do
    with {:ok, ot_session_id} <- OpenTok.create_session,
         ot_config <- Application.get_env(:live_auction, OpenTok),
         {:ok, token} <- OpenTok.generate_token(ot_session_id, :publisher, "publisher1"),
         opentok_params <- %{session_id: ot_session_id, token: token, config: ot_config}
    do
      render(conn, "dashboard.html", opentok_params: opentok_params)
    end
  end
end
