defmodule ZaZaarWeb.StreamChannelTest do
  use ZaZaarWeb.ChannelCase

  alias ZaZaarWeb.StreamChannel

  setup do
    channel = insert(:channel)
    {:ok, socket} = connect(UserSocket, %{})
    {:ok, socket: socket, channel: channel}
  end

  describe "join a channel" do
    test "anybody can join a stream channel", context do
      %{socket: socket, channel: channel} = context

      subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      receiving_topic = "user:joined"
      assert_broadcast(^receiving_topic, %{})
    end

    test "a signed in user can join a stream channel", context do
      %{channel: channel} = context

      user = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})

      subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      receiving_topic = "user:joined"
      assert_broadcast(^receiving_topic, payload)
      assert payload.user_id == user.id
    end
  end

  describe "streamer:show_start" do
    setup context do
      %{channel: channel} = context
      user = Repo.get(User, channel.streamer_id)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      {:ok, socket: socket_1}
    end

    test "streamer can start broadcasting on her own stream", context do
      %{socket: socket} = context

      params = %{message: "hello world"}
      ref = push(socket, "streamer:show_start", params)

      assert_broadcast("streamer:show_started", %{message: _})
      assert_reply(ref, :ok, %{token: "T1==" <> _, session_id: _, key: _})
    end
  end

  describe "viewer:joine" do
    test "member viewer can join through this event", context do
      %{channel: channel} = context
      viewer = insert(:viewer)
      {:ok, jwt, _} = Guardian.encode_and_sign(viewer)
      {:ok, socket} = connect(UserSocket, %{token: jwt})

      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      ref = push(socket_1, "viewer:join", %{})

      assert_broadcast("viewer:joined", payload)
      assert payload == %{id: viewer.id}
      assert_reply(ref, :ok, %{token: "T1==" <> _, session_id: _, key: _})
    end

    test "anonymous viewer can join through event", context do
      %{socket: socket, channel: channel} = context

      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      ref = push(socket_1, "viewer:join", %{})

      assert_broadcast("viewer:joined", %{})
      assert_reply(ref, :ok, %{token: "T1==" <> _, session_id: _, key: _})
    end
  end

  describe "user:send_message" do
    setup context do
      %{channel: channel} = context
      user = Repo.get(User, channel.streamer_id)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      {:ok, socket: socket_1}
    end

    @tag :skip
    test "all subscriber should receive user:message_sent with payload" do
    end
  end

  describe "terminate" do
    setup context do
      %{socket: socket, channel: channel} = context
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      {:ok, socket: socket_1}
    end

    test "broadcast stream:viewer_left when an anonymous user left", context do
      %{socket: socket} = context

      StreamChannel.terminate("", socket)

      assert_broadcast("viewer:left", %{})
    end

    test "broadcast stream:viewer_left when a user left", context do
      %{channel: channel} = context
      viewer = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(viewer)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      StreamChannel.terminate("", socket_1)

      assert_broadcast("viewer:left", payload)
      assert payload.user.id == viewer.id
    end

    test "broadcast stream:show_ended when the streamer left", context do
      %{channel: channel} = context
      streamer = Repo.get(User, channel.streamer_id)
      {:ok, jwt, _} = Guardian.encode_and_sign(streamer)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      socket_1 = subscribe_and_join!(socket, StreamChannel, "stream:" <> channel.streamer_id)

      StreamChannel.terminate("", socket_1)

      assert_broadcast("streamer:show_ended", _payload)
    end
  end
end
