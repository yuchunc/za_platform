defmodule ZaZaarWeb.StreamChannelTest do
  use ZaZaarWeb.ChannelCase, asycn: true

  alias ZaZaarWeb.StreamChannel

  import Mox

  setup :verify_on_exit!

  setup do
    stream = insert(:stream)
    streamer = Repo.get(User, stream.streamer_id)

    socket =
      sign_socket(streamer)
      |> subscribe_and_join!(StreamChannel, "stream:" <> stream.id)

    assert_broadcast("user:joined", _)
    {:ok, socket: socket, stream: stream, streamer: streamer}
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  describe "join a channel" do
    setup do
      {:ok, socket} = connect(UserSocket, %{})
      {:ok, stream: insert(:stream), socket: socket}
    end

    test "anybody can join a stream", ctx do
      %{stream: stream, socket: socket} = ctx

      subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.id)

      assert_broadcast("user:joined", %{})
    end

    test "a signed in user can join a streaming channel" do
      user = insert(:user)
      stream = insert(:stream)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})

      subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.id)

      assert_broadcast("user:joined", payload)
      assert payload.user_id == user.id
    end
  end

  describe "streamer:show_start" do
    test "streamer can start broadcasting on her own stream", ctx do
      %{socket: socket} = ctx
      params = %{message: "hello world"}
      ref = push(socket, "streamer:show_start", params)

      assert_broadcast("streamer:show_started", %{message: _})
      assert_reply(ref, :ok, %{token: "T1==" <> _, session_id: _, key: _})
    end
  end

  describe "streamer:upload_snapshot" do
    test "streamer can upload a video snapshot with provided secret" do
      key = random_string(32)
      stream = insert(:stream, upload_key: key)
      streamer = Repo.get(User, stream.id)
      socket = sign_socket(streamer)
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.id)

      push(socket_1, "streamer:upload_snapshot", %{upload_key: key, snapshot: random_string(32)})
      Process.sleep(10)

      refute Repo.get(Stream, stream.id) |> Map.get(:video_snapshot) |> is_nil
    end
  end

  describe "viewer:join" do
    test "member viewer can join through this event", ctx do
      %{stream: stream} = ctx
      viewer = insert(:user)
      socket = sign_socket(viewer)

      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.id)

      ref = push(socket_1, "viewer:join", %{})

      assert_broadcast("viewer:joined", payload)
      assert payload == %{id: viewer.id}
      assert_reply(ref, :ok, %{token: "T1==" <> _, session_id: _, key: _})
    end

    test "anonymous viewer can join through event", ctx do
      %{socket: socket, stream: stream} = ctx

      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.id)

      ref = push(socket_1, "viewer:join", %{})

      assert_broadcast("viewer:joined", %{})
      assert_reply(ref, :ok, %{token: "T1==" <> _, session_id: _, key: _})
    end
  end

  describe "stream:send_comment" do
    test "receive stream:comment_sent with comment in payload if a stream is active", ctx do
      %{socket: socket_signed, stream: stream} = ctx

      content = "Ga Ga Woo Lala ah~"

      push(socket_signed, "stream:send_comment", %{comment: content})

      assert_broadcast("stream:comment_sent", %{comment: comment})
      assert comment.user_id == stream.streamer_id
      assert comment.content == content
      assert comment.inserted_at
    end
  end

  describe "viewer:start_following" do
    test "viewer starts following the streamer", ctx do
    end
  end

  # describe "terminate" do
  #   setup ctx do
  #     %{socket: socket, channel: channel} = ctx
  #     socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

  #     {:ok, socket: socket_1}
  #   end

  #   test "broadcast stream:viewer_left when an anonymous user left", ctx do
  #     %{socket: socket} = ctx

  #     StreamChannel.terminate("", socket)

  #     assert_broadcast("viewer:left", %{})
  #   end

  #   test "broadcast stream:viewer_left when a user left", ctx do
  #     %{channel: channel} = ctx
  #     viewer = insert(:user)
  #     {:ok, jwt, _} = Guardian.encode_and_sign(viewer)
  #     {:ok, socket} = connect(UserSocket, %{token: jwt})
  #     socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

  #     StreamChannel.terminate("", socket_1)

  #     assert_broadcast("viewer:left", payload)
  #     assert payload.user.id == viewer.id
  #   end

  #   test "broadcast stream:show_ended when the streamer left", ctx do
  #     %{channel: channel} = ctx
  #     streamer = Repo.get(User, channel.streamer_id)
  #     {:ok, jwt, _} = Guardian.encode_and_sign(streamer)
  #     {:ok, socket} = connect(UserSocket, %{token: jwt})
  #     socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

  #     StreamChannel.terminate("", socket_1)

  #     assert_broadcast("streamer:show_ended", _payload)
  #   end
  # end
end
