defmodule LiveAuction.StreamingTest do
  use LiveAuction.DataCase

  import Mox

  alias LiveAuction.Streaming
  alias Streaming.Stream

  setup :verify_on_exit!

  describe "current_stream/1" do
    test "gets the current stream" do
      stream = insert(:stream)

      assert %Stream{} = Streaming.current_stream(stream.streamer_id)
    end
  end

  describe "new_session/1" do
    setup do
      {:ok, user: insert(:user)}
    end

    test "request a new session if doesn't have a stream", context do
      %{user: user, session_id: session_id} = context

      expect(OpenTok.ApiMock, :request_session_id, fn(_) ->
        {:ok, session_id}
      end)

      result = Streaming.new_session(user.id)

      assert {:ok, %Stream{ot_session_id: ^session_id}} = result
    end

    test "returns a previousely created stream", context do
      %{user: user, session_id: session_id} = context

      stream = insert(:stream, streamer_id: user.id, ot_session_id: session_id)

      assert {:ok, result} = Streaming.new_session(user.id)
      assert result.id == stream.id
      assert result.ot_session_id == session_id
    end
  end
end
