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

  describe "chat:history event" do
    setup context do
      %{user: user} = context
      user_1 = insert(:user)
      socket = subscribe_and_join!(sign_socket(user), UserChannel, "user:" <> user.id)
      messages = build_list(40, :message, user_id: Enum.random([user.id, user_1.id]))
      history = insert(:history, user_ids: [user.id, user_1.id], messages: messages)
      {:ok, socket: socket, user_1: user_1, history: history}
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
      socket = subscribe_and_join!(sign_socket(user), UserChannel, "user:" <> user.id)
      socket1 = subscribe_and_join!(sign_socket(user1), UserChannel, "user:" <> user1.id)

      {:ok, socket: socket, user1: user1, socket1: socket1}
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

  describe "[INTERNAL] notify:new_notice" do
    setup context do
      %{user: user} = context
      socket = subscribe_and_join!(sign_socket(user), UserChannel, "user:" <> user.id)

      {:ok, socket: socket}
    end

    test "when other service part pushes notice to this, it broadcast to the client, and write to db", context do
      %{socket: socket} = context
      user1_id = Ecto.UUID.generate

      push socket, "notify:new_notice", %{type: :new_follower, from_id: user1_id}

      valid_payload = %{"from_id" => user1_id}
      assert_broadcast("notify:new_follower", ^valid_payload)
    end
  end
end
