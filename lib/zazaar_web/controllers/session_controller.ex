defmodule ZaZaarWeb.SessionController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  alias ZaZaar.Auth.Guardian

  def show(conn, _params) do
    render(conn, "sign_in.html")
  end

  def create(conn, params) do
    with %{"email" => email, "password" => password} <- params,
         {:ok, user} <- Account.login(email, password) do
      conn
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: membership_path(conn, :show))
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end
end
