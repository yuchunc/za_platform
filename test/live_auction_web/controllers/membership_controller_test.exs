defmodule LiveAuctionWeb.MembershipControllerTest do
  use LiveAuctionWeb.ConnCase, async: true

  describe "GET /m" do
    test "gets a session_id", context do
      %{conn: conn} = context

      result = conn
               |> get(membership_path(conn, :show))
               |> html_response(200)
               |> IO.inspect(label: "foo")
    end
  end
end
