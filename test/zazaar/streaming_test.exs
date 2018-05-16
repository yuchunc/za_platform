defmodule ZaZaar.StreamingTest do
  use ZaZaar.DataCase

  import Mox

  alias ZaZaar.Streaming
  alias Streaming.Channel

  setup [:verify_on_exit!, :insert_user]

  defp insert_user(context) do
    Map.put_new(context, :user, insert(:streamer))
  end

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

  describe "create_channel/1" do
    test "create a channel with OT session", context do
      %{user: user, session_id: session_id} = context

      expect(OpenTok.ApiMock, :request_session_id, fn _ ->
        {:ok, session_id}
      end)

      assert {:ok, %Channel{ot_session_id: ^session_id}} = Streaming.create_channel(user)
    end

    test "user must be streamer", context do
      %{user: user, session_id: session_id} = context

      assert {:error, :invalid_user} = Streaming.create_channel(user.id)
    end
  end

  describe "start_streaming/1" do
    setup do
      {:ok, channel: insert(:channel)}
    end

    test "returns a created stream", context do
      %{user: user} = context

      # assert {:ok, result} = Streaming.new_session(user.id)
      # assert result.id == stream.id
      # assert result.ot_session_id == session_id
    end
  end

  describe "append_comment/2" do
    setup do
      {:ok, stream: insert(:stream)}
    end

    test "append comment to a stream struct", context do
      %{user: user, stream: stream} = context

      params = %{
        user_id: user.id,
        content: "We don’t have the Tesseract. It was destroyed on Asgard."
      }

      assert {:ok, stream} = Streaming.append_comment(stream, params)
      assert Enum.count(stream.comments) == 1
      assert stream.comments |> List.first() |> Map.get(:user_id) == user.id
    end
  end
end
