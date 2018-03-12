defmodule LiveAuctionWeb.MembershipController do
  use LiveAuctionWeb, :controller

  def show(conn, _) do
    {:ok, ot_session_id} = OpenTok.create_session
    require IEx; IEx.pry

    render(conn, "dashboard.html", ot_session_id: ot_session_id)
  end
end
