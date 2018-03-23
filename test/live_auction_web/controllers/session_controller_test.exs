defmodule LiveAuctionWeb.SessionControllerTest do
  use LiveAuctionWeb.ConnCase

  describe "POST /auth" do
    test "log user in with correct email and password", context do
      %{conn: conn} = context
      user = insert(:user)

      params = Map.take(user, [:email, :password])

      response = conn
                 |> post(session_path(conn, :create), params)

      response
      |> html_response(302)

      assert response.cookies["token"]
      assert response.resp_headers |> Enum.filter(&(elem(&1, 0) == "auth")) |> Enum.count == 1
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
