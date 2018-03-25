defmodule LiveAuctionWeb.SessionController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  # create a session
  def create(conn, params) do
    with %{"email" => email, "password" => password} <- params,
         {:ok, user} <- Account.authenticate(email, password)
    do
      conn
      |> Guardian.Plug.remember_me(user)
      |> Guardian.Plug.sign_in(user)
      |> IO.inspect(label: "conn")
      #|> put_resp_cookie("token", refresh_token, secure: true)
      #|> put_resp_header("auth", access_token)
      |> redirect(to: membership_path(conn, :show))
    end
  end

  # delete a session
end
