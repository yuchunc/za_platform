defmodule LiveAuctionWeb.SessionControllerTest do
  use LiveAuctionWeb.ConnCase

  describe "POST /auth" do
    test "log user in with correct email and password", context do
      %{conn: conn} = context
      user = insert(:user)

      params = Map.take(user, [:email, :password])

      result = conn
               |> post(session_path(conn, :create), params)

      html_response(result, 302)

      assert get_session(result, "auth")
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
