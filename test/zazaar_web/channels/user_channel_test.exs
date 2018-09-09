defmodule ZaZaarWeb.UserChannelTest do
  use ZaZaarWeb.ChannelCase

  alias ZaZaarWeb.UserChannel

  setup do
    user = insert(:streamer)
    {:ok, user: user}
  end

  describe "join channel" do
    test "produces wrong error if miss matched" do
      {:ok, socket} = connect(UserSocket, %{})
      user = insert(:viewer)

      assert join(socket, UserChannel, "user:" <> user.id) == {:error, :wrong_user}
    end

    test "only the user can use own channel", context do
      %{user: user} = context

      user
      |> sign_socket
      |> subscribe_and_join!(UserChannel, "user:" <> user.id)

      assert_broadcast("user:signed_in", _)
    end
  end

  describe "add_post event" do
    setup context do
      %{user: user} = context

      {:ok, socket: join_channel(user)}
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

  describe "chat:history event" do
    setup context do
      %{user: user} = context
      user_1 = insert(:user)
      messages = build_list(40, :message, user_id: Enum.random([user.id, user_1.id]))
      history = insert(:history, user_ids: [user.id, user_1.id], messages: messages)
      {:ok, socket: join_channel(user), user_1: user_1, history: history}
    end

    test "gets a list of latest chat", context do
      %{socket: socket, user: main, user_1: target} = context
      ref = push(socket, "chat:history", %{user_id: target.id})

      assert_reply(ref, :ok, %{chats: chats})

      Enum.each(chats, fn c ->
        assert c.user_id in [main.id, target.id]
      end)
    end

    test "gets a the next list of chats", context do
      %{socket: socket, user_1: target} = context
      ref = push(socket, "chat:history", %{user_id: target.id})
      assert_reply(ref, :ok, %{chats: chats})

      ref_1 = push(socket, "chat:history", %{user_id: target.id, page: 2})
      assert_reply(ref_1, :ok, %{chats: chats_1})

      refute chats == chats_1
    end
  end

  describe "chat:send_message event" do
    setup context do
      %{user: user} = context
      user1 = insert(:user)

      {:ok, socket: join_channel(user), user1: user1, socket1: join_channel(user1)}
    end

    test "replys :ok", context do
      %{socket: socket, user1: user1} = context
      content = Faker.Lorem.sentence(2)

      ref = push(socket, "chat:send_message", %{to_id: user1.id, body: content})

      assert_reply(ref, :ok, %{})
    end

    test "the other person receives chat:received_message event with message", context do
      %{user: user, socket: socket} = context
      content = Faker.Lorem.sentence(2)

      push(socket, "chat:receive_message", %{from_id: user.id, body: content})

      valid_payload = %{from_id: user.id, body: content}
      assert_broadcast("chat:received_message", ^valid_payload)
    end
  end

  describe "follower:add event" do
    setup context do
      %{user: user} = context

      {:ok, socket: join_channel(user)}
    end

    test "follows another user", context do
      %{socket: socket} = context
      followee = insert(:user)
      ref = push(socket, "follower:add", %{followee_id: followee.id})

      assert_reply(ref, :ok, %{})
    end
  end

  describe "follower:remove event" do
    setup context do
      %{user: user} = context

      {:ok, socket: join_channel(user)}
    end

    test "stop following another user", context do
      %{socket: socket} = context
      ref = push(socket, "follower:remove", %{followee_id: Ecto.UUID.generate})

      assert_reply(ref, :ok, %{})
    end
  end

  describe "[INTERNAL] :new_notice" do
    setup context do
      %{user: user} = context

      {:ok, socket: join_channel(user)}
    end

    test "when other service pushes notice to this, it broadcast to the client", context do
      %{socket: socket} = context
      user1_id = Ecto.UUID.generate()

      push(socket, "notify:new_notice", %{type: :new_follower, from_id: user1_id})

      valid_payload = %{"from_id" => user1_id}
      assert_broadcast("notify:new_follower", ^valid_payload)
    end
  end

  defp join_channel(%User{} = user) do
    user
    |> sign_socket
    |> subscribe_and_join!(UserChannel, "user:" <> user.id)
  end
end
