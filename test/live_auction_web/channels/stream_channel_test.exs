defmodule LiveAuctionWeb.StreamChannelTest do
  use LiveAuctionWeb.ChannelCase

  alias LiveAuctionWeb.StreamChannel

  setup do
    stream = insert(:stream)
    {:ok, socket: socket(), stream: stream}
  end

  describe "join a channel" do
    test "anybody can join a stream channel", context do
      %{socket: socket, stream: stream} = context

      subscribe_and_join(socket, StreamChannel, "stream:" <> stream.streamer_id)

      receiving_topic = "stream:joined"

      assert_broadcast(^receiving_topic, %{})
    end

    test "a signed in user can join a stream channel", context do
      %{stream: stream} = context

      user = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      receiving_topic = "stream:joined"

      subscribe_and_join(socket, StreamChannel, "stream:" <> stream.streamer_id)

      assert_broadcast(^receiving_topic, payload)
      assert payload.user.id == user.id
    end
  end

  describe "stream:show_start" do
    setup context do
      %{stream: stream} = context
      user = Repo.get(User, stream.streamer_id)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{token: jwt})
      new_socket = subscribe_and_join!(socket, StreamChannel, "stream:" <> stream.streamer_id)

      {:ok, socket: new_socket}
    end

    test "streamer can start broadcasting on her own stream", context do
      %{socket: socket} = context

      params = %{message: "hello world"}
      ref = push(socket, "stream:show_start", params)

      assert_broadcast("stream:show_started", %{message: _})
      assert_reply(ref, :ok, %{token: "T1==" <> _})
    end
  end
end
