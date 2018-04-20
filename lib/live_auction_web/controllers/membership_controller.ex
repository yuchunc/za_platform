defmodule LiveAuctionWeb.MembershipController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  def show(conn, _) do
    render(conn, "dashboard.html")
  end
end
