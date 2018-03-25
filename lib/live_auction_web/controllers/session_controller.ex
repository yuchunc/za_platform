defmodule LiveAuctionWeb.SessionController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  alias LiveAuction.Auth.Guardian

  # create a session
  def create(conn, params) do
    with %{"email" => email, "password" => password} = creds <- params,
         {:ok, user} <- Account.authenticate(email, password),
         signed_in_conn <- Guardian.Plug.sign_in(conn, user)
    do
      redirect(conn, to: membership_path(conn, :show))
    end
  end

  # delete a session
end
