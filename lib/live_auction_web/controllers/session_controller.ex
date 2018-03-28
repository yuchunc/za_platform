defmodule LiveAuctionWeb.SessionController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  alias LiveAuction.Auth.Guardian

  def show(_, _) do
    {:error, :invalid_credentials}
  end

  # create a session
  def create(conn, params) do
    with %{"email" => email, "password" => password} = creds <- params,
         {:ok, user} <- Account.authenticate(email, password)
    do
      conn
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: membership_path(conn, :show))
    end
  end

  # delete a session
end
