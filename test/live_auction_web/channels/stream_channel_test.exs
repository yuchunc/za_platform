defmodule LiveAuctionWeb.StreamChannelTest do
  use LiveAuctionWeb.ChannelCase, async: true

  alias LiveAuctionWeb.StreamChannel

  setup do
    stream = insert(:stream)
    {:ok, socket: socket(), stream: stream}
  end

  describe "join stream:<streamer_id>" do
    test "anybody can join a stream channel", context do
      %{socket: socket, stream: stream} = context

      subscribe_and_join(socket, StreamChannel, "stream:" <> stream.streamer_id)

      receiving_topic = "stream:#{stream.streamer_id}:joined"

      assert_broadcast(^receiving_topic, %{})
    end

    test "a signed in user can join a stream channel", context do
      %{stream: stream} = context

      user = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      {:ok, socket} = connect(UserSocket, %{token: jwt})

      subscribe_and_join(socket, StreamChannel, "stream:" <> stream.streamer_id)

      receiving_topic = "stream:#{stream.streamer_id}:joined"

      assert_broadcast(^receiving_topic, payload)
      assert payload.user.id == user.id
    end
  end
end
