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

  describe "add_post event" do
    setup context do
      %{user: user} = context

      socket = subscribe_and_join!(sign_socket(user), UserChannel, "user:" <> user.id)

      {:ok, socket: socket}
    end

    test "adds an post to the user feed", context do
      %{socket: socket, user: user} = context

      random_string = Faker.Lorem.sentence()
      push(socket, "add_post", %{content: random_string})

      assert_broadcast("post_added", %{post: _})

      db_post =
        Post
        |> where(user_id: ^user.id)
        |> Repo.all()
        |> List.last()

      assert db_post.body == random_string
    end
  end
end
