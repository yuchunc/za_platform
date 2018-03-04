defmodule LiveAuctionWeb.MembershipController do
  use LiveAuctionWeb, :controller

  def index(conn, _) do
    render(conn, "dashboard.html")
  end
end
