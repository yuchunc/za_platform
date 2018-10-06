defmodule ZaZaarWeb.StreamingControllerTest do
  use ZaZaarWeb.ConnCase, async: true

  describe "GET /m/streaming" do
    # test "redirects to root page", context do
    #   %{conn: conn0} = context
    #   conn = conn0
    #     |> get(membership_streaming_path(conn0, :show))

    #   assert redirected_to(conn) == live_stream_path(conn, :index)
    # end

    # test "starts a stream for a streamer channel", context do
    #   %{conn: conn, user: streamer} = gen_signed_in_user(context)

    #   insert(:channel, streamer_id: streamer.id)

    #   result =
    #     conn
    #     |> get(membership_streaming_path(conn, :show))
    #     |> html_response(200)

    #   assert Regex.scan(~r/jwt:/, result)
    #   assert Regex.scan(~r/streamer_id:/, result)
    # end

    # TODO move this to controller action where transition user to streamer
    # test "gets a session_id from opentok", context do
    #   %{conn: conn} = context

    #   session_id = "1_MX40NjA3NDA1Mn5-MTUy000000000000N35LNjFOVkI3RWR6M2U3dUw4aXZyQ1hOU3B-fg"
    #   expect(OpenTok.ApiMock, :request_session_id, fn _ ->
    #     {:ok, session_id}
    #   end)

    #   result =
    #     conn
    #     |> get(membership_streaming_path(conn, :show))
    #     |> html_response(200)

    #   assert Regex.scan(~r/session_id: (\d_\w{15}-\w{51}-\w{2})/, result)
    # end
  end
end
