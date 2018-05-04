defmodule LiveAuctionWeb.SessionControllerTest do
  use LiveAuctionWeb.ConnCase

  describe "POST /auth" do
    test "log user in with correct email and password" do
      user = insert(:user)
      params = Map.take(user, [:email, :password])

      conn =
        build_conn()
        |> post(session_path(build_conn(), :create), params)

      assert redirected_to(conn) == membership_path(conn, :show)
    end

    test "throws 401 with incorrect email password combination", context do
      %{conn: conn} = context

      params = %{email: "bad@email.com", password: "badpassword"}

      conn
      |> post(session_path(conn, :create), params)
      |> html_response(401)
    end
  end
end
