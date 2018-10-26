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
    test "gets a list of channels" do
      channel_list = insert_list(10, :channel)

      result = Streaming.get_channels()

      Enum.each(result, &assert(%Channel{} = &1))
      assert Enum.count(result) == 10

      assert result |> Enum.map(& &1.id) |> Enum.sort() ==
               channel_list |> Enum.map(& &1.id) |> Enum.sort()
    end
  end

  describe "get_channels/1" do
    test "gets list of channels with the last active snapshot with snapshot: true" do
      insert_pair(:channel)
      |> Enum.map(fn c ->
        insert(:stream, channel: c, video_snapshot: "jibberish")
      end)

      result = Streaming.get_channels(snapshot: true)

      assert Enum.map(result, & &1.video_snapshot)
             |> Enum.reject(&is_nil/1)
             |> Enum.count() == 2
    end
  end

  describe "get_channel/1" do
    test "gets the current channel" do
      channel = insert(:channel)

      assert %Channel{} = Streaming.get_channel(channel.streamer_id)
    end
  end

  describe "get_active_stream/1" do
    setup do
      streamer_id = insert(:user) |> Map.get(:id)
      channel = insert(:channel, streamer_id: streamer_id)
      stream = insert(:stream, channel: channel)

      {:ok, streamer_id: streamer_id, channel: channel, stream: stream}
    end

    test "gets the active stream from streamer_id", context do
      %{streamer_id: streamer_id, stream: %{id: stream_id}} = context

      assert Streaming.get_active_stream(streamer_id) |> Map.get(:id) == stream_id
    end

    test "gets the active stream from channel", context do
      %{stream: %{id: stream_id}, channel: channel} = context

      assert Streaming.get_active_stream(channel) |> Map.get(:id) == stream_id
    end
  end

  describe "find_or_create_channel/1" do
    test "create a channel with OT session", context do
      %{user: user, session_id: session_id} = context

      expect(OpenTok.ApiMock, :request_session_id, fn _ ->
        {:ok, session_id}
      end)

      assert {:ok, result} = Streaming.find_or_create_channel(user)
      assert result.ot_session_id == session_id
    end
  end

  describe "gen_snapshot_key/1" do
    setup do
      {:ok, stream: insert(:stream)}
    end

    test "generates a upload key for uploading snapshot to an active stream", context do
      %{stream: stream} = context

      assert {:ok, _key} = Streaming.gen_snapshot_key(stream.channel)
    end

    test "error when no stream is found" do
      stream = insert(:stream, archived_at: NaiveDateTime.utc_now())

      assert {:error, :not_found} = Streaming.gen_snapshot_key(stream.channel)
    end
  end

  describe "update_snapshot/3" do
    setup do
      {:ok, stream: insert(:stream, upload_key: "foobar")}
    end

    test "find active stream with matching upload key, and store the data in to it", context do
      %{stream: stream} = context

      assert :ok =
               Streaming.update_snapshot(
                 stream.channel,
                 "foobar",
                 :crypto.strong_rand_bytes(12) |> Base.encode64()
               )
    end

    test "update snapshot of a given stream", context do
      %{stream: stream} = context

      assert :ok =
               Streaming.update_snapshot(
                 stream,
                 "foobar",
                 :crypto.strong_rand_bytes(12) |> Base.encode64()
               )
    end

    test "error if no valid stream is found" do
      stream = insert(:stream, upload_key: "foobar")

      assert {:error, :not_found} =
               Streaming.update_snapshot(
                 stream.channel,
                 "somethingelse",
                 :crypto.strong_rand_bytes(12) |> Base.encode64()
               )
    end
  end

  describe "start_stream/1" do
    setup context do
      %{user: streamer} = context
      {:ok, channel: insert(:channel, streamer_id: streamer.id)}
    end

    test "returns a stream", context do
      %{user: streamer} = context

      assert {:ok, stream} = Streaming.start_stream(streamer.id)
      assert stream.__struct__ == ZaZaar.Streaming.Stream
    end

    test "faile if channel already has another active stream", context do
      %{user: streamer} = context
      assert {:ok, _stream} = Streaming.start_stream(streamer.id)
      assert {:error, :another_stream_is_active} = Streaming.start_stream(streamer.id)
    end

    test "failed to find the streamer's channel" do
      streamer = insert(:streamer)

      assert {:error, :cannot_start_stream} = Streaming.start_stream(streamer.id)
    end
  end

  describe "end_stream/1" do
    setup context do
      %{user: streamer} = context
      channel = insert(:channel, streamer_id: streamer.id)
      {:ok, stream: insert(:stream, channel: channel)}
    end

    test "sets the archived_at time on stream", context do
      %{stream: stream} = context

      assert {:ok, stream1} = Streaming.end_stream(stream.channel.streamer_id)
      assert stream1.archived_at
    end

    test "errors when invalid stream is used" do
      assert {:error, :invalid_channel} = Streaming.end_stream(Ecto.UUID.generate())
    end

    test "archived stream cannot be touched" do
      streamer = insert(:streamer)
      channel = insert(:channel, streamer_id: streamer.id)
      insert(:stream, channel: channel, archived_at: NaiveDateTime.utc_now())

      assert {:error, :invalid_channel} = Streaming.end_stream(streamer.id)
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

      assert {:ok, comment} = Streaming.append_comment(stream, params)
      assert Map.get(comment, :user_id) == user.id
    end
  end

  describe "stream_to_facebook" do
    setup do
      facebook_key = "2066820000000027?s_ps=1&s_vt=api&a=ATg43wd400000000"
      channel = insert(:channel, facebook_key: facebook_key)
      {:ok, channel: channel}
    end

    test "if channel doesn't have facebook_key, does nothing" do
      channel = insert(:channel, facebook_key: nil)
      assert Streaming.stream_to_facebook(channel) == nil
    end

    test "activates a rtmp stream on Facebook", context do
      expect(OpenTok.ApiMock, :external_broadcast, fn _, _, _ ->
        :ok
      end)

      assert Streaming.stream_to_facebook(context.channel) == :ok
    end
  end

  describe "update_stream" do
    setup do
      {:ok, stream: insert(:stream), recording_id: Ecto.UUID.generate()}
    end

    test "can update a stream by stream id", ctx do
      %{stream: stream0, recording_id: recording_id} = ctx
      {:ok, stream1} = Streaming.update_stream(stream0.id, %{recording_id: recording_id})

      refute stream1.recording_id == stream0.recording_id
    end

    test "can update a stream by stream struct", ctx do
      %{stream: stream0, recording_id: recording_id} = ctx
      {:ok, stream1} = Streaming.update_stream(stream0, %{recording_id: recording_id})

      refute stream1.recording_id == stream0.recording_id
    end
  end
end
