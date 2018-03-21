defmodule LiveAuctionWeb.SessionController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  # create a session
  def create(conn, params) do
    {:error, :invalid_credentials}
  end

  # delete a session
end
