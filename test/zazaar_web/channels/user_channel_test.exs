defmodule ZaZaarWeb.UserChannelTest do
  use ZaZaarWeb.ChannelCase

  alias ZaZaarWeb.UserChannel

  setup do
    user = insert(:streamer)
    {:ok, socket: sign_socket(user), user: user}
  end

  describe "join channel" do
    test "produces wrong error if miss matched" do
      {:ok, socket} = connect(UserSocket, %{})
      user = insert(:viewer)

      assert join(socket, UserChannel, "user:" <> user.id) == {:error, :wrong_user}
    end

    test "only the user can use own channel", context do
      %{socket: socket, user: user} = context

      subscribe_and_join!(socket, UserChannel, "user:" <> user.id)

      assert_broadcast("user:signed_in", _)
    end
  end
end
