defmodule LiveAuction.Auth.ErrorHandler do
  use LiveAuctionWeb, :controller

  def auth_error(conn, _, _opts) do
    redirect(conn, to: session_path(conn, :show))
  end
end
