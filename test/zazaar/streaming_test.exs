defmodule ZaZaar.StreamingTest do
  use ZaZaar.DataCase

  import Mox

  alias ZaZaar.Streaming

  setup [:verify_on_exit!, :insert_user]

  defp insert_user(context) do
    Map.put_new(context, :user, insert(:user))
  end

  describe "get_stream/1" do
    setup do
      stream = insert(:stream)

      {:ok, stream: stream}
    end

    test "gets the active stream from streamer_id", context do
      %{stream: stream} = context

      stream1 = Streaming.get_stream(stream.streamer_id)

      assert stream1.id == stream.id
      assert is_nil(stream1.archived_at)
    end

    test "gets stream by stream_id", context do
      %{stream: %{id: stream_id}} = context

      assert Streaming.get_stream(stream_id) |> Map.get(:id) == stream_id
    end
  end

  describe "gen_snapshot_key/1" do
    setup do
      {:ok, stream: insert(:stream)}
    end

    test "generates a upload key for uploading snapshot to an active stream", context do
      %{stream: stream} = context

      assert {:ok, _key} = Streaming.gen_snapshot_key(stream)
      assert {:ok, _key} = Streaming.gen_snapshot_key(stream.id)
    end

    test "error when stream is archived" do
      stream = insert(:stream, archived_at: NaiveDateTime.utc_now())

      assert {:error, _} = Streaming.gen_snapshot_key(stream)
    end

    test "error when stream is not found" do
      assert {:error, :stream_not_found} = Streaming.gen_snapshot_key(Ecto.UUID.generate())
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
                 stream.streamer_id,
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
      assert {:error, :stream_not_found} =
               Streaming.update_snapshot(
                 Ecto.UUID.generate(),
                 "somethingelse",
                 :crypto.strong_rand_bytes(12) |> Base.encode64()
               )
    end
  end

  describe "start_stream/1" do
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
  end

  describe "end_stream/1" do
    setup do
      {:ok, stream: insert(:stream)}
    end

    test "sets the archived_at time on stream", context do
      %{stream: stream} = context

      assert {:ok, stream1} = Streaming.end_stream(stream)
      assert stream1.archived_at
    end

    test "sets the archived_at time on stream by streamer_id", context do
      %{stream: stream} = context

      assert {:ok, stream1} = Streaming.end_stream(stream.streamer_id)
      assert stream1.archived_at
    end

    test "errors when stream is not found" do
      assert {:error, :stream_not_found} = Streaming.end_stream(Ecto.UUID.generate())
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

  describe "stream_to_facebook/3" do
    setup do
      facebook_key = "2066820000000027?s_ps=1&s_vt=api&a=ATg43wd400000000"
      {:ok, stream: insert(:stream), fb_key: facebook_key}
    end

    test "if channel doesn't have facebook_key, does nothing", ctx do
      %{stream: stream} = ctx

      expect(OpenTok.ApiMock, :external_broadcast, fn _, _, _ ->
        {:error, :noclient}
      end)

      session_id = "some_ot_session_id"
      assert {:ok, stream1} = Streaming.stream_to_facebook(stream, nil, session_id)
      assert stream1.fb_stream_key == nil
    end

    test "activates a rtmp stream on Facebook", ctx do
      %{stream: stream, fb_key: fb_key} = ctx
      session_id = "some_ot_session_id"

      expect(OpenTok.ApiMock, :external_broadcast, fn _, _, _ ->
        :ok
      end)

      assert {:ok, stream1} = Streaming.stream_to_facebook(stream, fb_key, session_id)
      assert stream1.fb_stream_key == fb_key
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

    test "archived stream cannot be touched" do
      stream = insert(:stream, archived_at: NaiveDateTime.utc_now())

      assert {:error, :stream_archived} = Streaming.update_stream(stream, %{upload_key: "baz"})
    end
  end
end
