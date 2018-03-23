defmodule LiveAuctionWeb.SessionController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  # create a session
  def create(conn, params) do
    with %{"email" => email, "password" => password} = creds <- params,
         {:ok, token} <- Account.authenticate(email, password)
    do
      conn
      |> put_session("auth", token)
      |> redirect(to: membership_path(conn, :show))
    end
  end

  # delete a session
end
