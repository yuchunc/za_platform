defmodule ZaZaar.StreamingTest do
  use ZaZaar.DataCase

  import Mox

  alias ZaZaar.Streaming
  alias Streaming.Channel

  setup :verify_on_exit!

  describe "get_channels/0" do
    test "gets a list of streams" do
      channel_list = insert_list(10, :channel)

      result = Streaming.get_channels()

      Enum.each(result, &assert(%Channel{} = &1))
      assert Enum.count(result) == 10

      assert result |> Enum.map(& &1.id) |> Enum.sort() ==
               channel_list |> Enum.map(& &1.id) |> Enum.sort()
    end
  end

  describe "current_channel_for/1" do
    test "gets the current stream" do
      channel = insert(:channel)

      assert %Channel{} = Streaming.current_channel_for(channel.streamer_id)
    end
  end

  describe "new_session/1" do
    setup do
      {:ok, user: insert(:user)}
    end

    test "request a new session if doesn't have a stream", context do
      %{user: user, session_id: session_id} = context

      expect(OpenTok.ApiMock, :request_session_id, fn _ ->
        {:ok, session_id}
      end)

      result = Streaming.new_session(user.id)

      assert {:ok, %Channel{ot_session_id: ^session_id}} = result
    end

    test "returns a previousely created stream", context do
      %{user: user, session_id: session_id} = context

      stream = insert(:channel, streamer_id: user.id, ot_session_id: session_id)

      assert {:ok, result} = Streaming.new_session(user.id)
      assert result.id == stream.id
      assert result.ot_session_id == session_id
    end
  end

  describe "append_comment/2" do
    setup do
      {:ok, user: insert(:user), stream: insert(:stream)}
    end

    test "append comment to a stream struct", context do
      %{user: user, stream: stream} = context

      params = %{user_id: user.id, content: "We don’t have the Tesseract. It was destroyed on Asgard."}

      assert {:ok, stream} = Streaming.append_comment(stream, params)
      assert Enum.count(stream.comments) == 1
      assert stream.comments |> List.first |> Map.get(:user_id) == user.id
    end
  end
end
