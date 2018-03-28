defmodule LiveAuctionWeb.MembershipControllerTest do
  use LiveAuctionWeb.ConnCase, async: true

  describe "GET /m" do
    test "redirects to login page" do
      conn = build_conn()
      conn
      |> get(membership_path(conn, :show))
      |> html_response(302)
    end

    test "gets a session_id", context do
      %{conn: conn} = context

      result = conn
               |> get(membership_path(conn, :show))
               |> html_response(200)

      assert Regex.scan(~r/session_id: (\d_\w{15}-\w{51}-\w{2})/, result)
    end
  end
end
