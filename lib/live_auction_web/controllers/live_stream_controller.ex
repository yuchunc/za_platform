defmodule LiveAuctionWeb.LiveStreamController do
  use LiveAuctionWeb, :controller

  def show(conn, _params) do
    render conn, "show.html"
  end
end
