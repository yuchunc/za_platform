defmodule ZaZaarWeb.StreamChannelTest do
  use ZaZaarWeb.ChannelCase

  alias ZaZaarWeb.StreamChannel

  setup do
    stream = insert(:stream)
    {:ok, socket} = connect(UserSocket, %{})
    {:ok, socket: socket, stream: stream}
  end

  describe "join a channel" do
    test "anybody can join a stream channel", context do
      %{socket: socket, stream: stream} = context

      subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      receiving_topic = "user:joined"
      assert_broadcast(^receiving_topic, %{})
    end

    test "a signed in user can join a stream channel", context do
      %{stream: stream} = context

      user = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})

      subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      receiving_topic = "user:joined"
      assert_broadcast(^receiving_topic, payload)
      assert payload.user_id == user.id
    end
  end

  describe "streamer:show_start" do
    setup context do
      %{stream: stream} = context
      user = Repo.get(User, stream.streamer_id)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      {:ok, socket: socket_1}
    end

    test "streamer can start broadcasting on her own stream", context do
      %{socket: socket} = context

      params = %{message: "hello world"}
      ref = push(socket, "stream:show_start", params)

      assert_broadcast("streamer:show_started", %{message: _})
      assert_reply(ref, :ok, %{token: "T1==" <> _})
    end
  end

  describe "user:send_message" do
    setup context do
      %{stream: stream} = context
      user = Repo.get(User, stream.streamer_id)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      {:ok, socket: socket_1}
    end
  end

  describe "terminate" do
    setup context do
      %{socket: socket, stream: stream} = context
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      {:ok, socket: socket_1}
    end

    test "broadcast stream:viewer_left when an anonymous user left", context do
      %{socket: socket} = context

      StreamChannel.terminate("", socket)

      assert_broadcast("viewer:left", %{})
    end

    test "broadcast stream:viewer_left when a user left", context do
      %{stream: stream} = context
      viewer = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(viewer)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      StreamChannel.terminate("", socket_1)

      assert_broadcast("viewer:left", payload)
      assert payload.user.id == viewer.id
    end

    test "broadcast stream:show_ended when the streamer left", context do
      %{stream: stream} = context
      streamer = Repo.get(User, stream.streamer_id)
      {:ok, jwt, _} = Guardian.encode_and_sign(streamer)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      StreamChannel.terminate("", socket_1)

      assert_broadcast("streamer:show_ended", _payload)
    end
  end
end
