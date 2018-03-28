defmodule LiveAuction.Auth.ErrorHandler do
  use LiveAuctionWeb, :controller

  def auth_error(conn, _, _opts) do
    redirect(conn, to: page_path(conn, :index))
  end
end
