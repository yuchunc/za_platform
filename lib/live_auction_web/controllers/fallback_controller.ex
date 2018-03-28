defmodule LiveAuctionWeb.FallbackController do
  use LiveAuctionWeb, :controller

  alias LiveAuctionWeb.ErrorView

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> render(ErrorView, "401.html")
  end
end
