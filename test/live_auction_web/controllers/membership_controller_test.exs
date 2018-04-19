defmodule LiveAuctionWeb.MembershipControllerTest do
  use LiveAuctionWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  describe "GET /m" do
    test "redirects to login page" do
      conn = build_conn()
             |> get(membership_path(build_conn(), :show))

      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "gets a session_id from opentok", context do
      %{conn: conn} = context

      insert(:user)

      session_id = "1_MX40NjA3NDA1Mn5-MTUy000000000000N35LNjFOVkI3RWR6M2U3dUw4aXZyQ1hOU3B-fg"
      expect(OpenTok.ApiMock, :request_session_id, fn(_) ->
        {:ok, session_id}
      end)

      result = conn
               |> get(membership_path(conn, :show))
               |> html_response(200)

      assert Regex.scan(~r/session_id: (\d_\w{15}-\w{51}-\w{2})/, result)
    end
  end
end
