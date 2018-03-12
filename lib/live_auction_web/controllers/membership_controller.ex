defmodule LiveAuctionWeb.MembershipController do
  use LiveAuctionWeb, :controller

  def show(conn, _) do
    with {:ok, ot_session_id} <- OpenTok.create_session,
         ot_config <- Application.get_env(:live_auction, OpenTok)
    do
      render(conn, "dashboard.html", ot_config: ot_config, ot_session_id: ot_session_id)
    end
  end
end
