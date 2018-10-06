defmodule ZaZaarWeb.SessionController do
  use ZaZaarWeb, :controller

  alias ZaZaar.Auth.Guardian.Plug, as: GPlug

  plug(Ueberauth)

  action_fallback(FallbackController)

  def show(conn, _params) do
    render(conn, "sign_in.html")
  end

  def create(conn, params) do
    with %{"email" => email, "password" => password} <- params,
         {:ok, user} <- Account.login(email, password) do
      conn
      |> GPlug.sign_in(user)
      |> redirect(to: membership_path(conn, :show))
    end
  end

  def delete(conn, _params) do
    conn
    |> GPlug.sign_out()
    |> put_flash(:info, "登出成功！")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "驗證失敗！")
    |> redirect(to: "/")
  end

  # def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
  #   with {:ok, user} <- Account.fb_auth(auth.uid, auth.info),
  #        {:ok, token} <- Guardian.encode_and_sign(user),
  #        {:ok, conn1} <- add_data_to_conn(conn, user, token)
  #   do
  #     Streaming.find_or_create_channel(user)

  #     conn1
  #     |> put_flash(:success, "登入成功！")
  #     |> redirect(to: "/")
  #   else
  #     error ->
  #       conn1
  #       |> put_flash(inspect(error))
  #       |> redirect(to: live_stream_path(conn, :index))
  #   end
  # end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    {:ok, user} = Account.fb_auth(auth.uid, auth.info)

    Streaming.find_or_create_channel(user)

    conn
    |> GPlug.sign_in(user)
    |> put_flash(:success, "登入成功！")
    |> redirect(to: "/")
  end
end
