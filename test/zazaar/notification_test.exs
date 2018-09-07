defmodule ZaZaar.NotificationTest do
  use ZaZaar.DataCase

  alias ZaZaar.Notification

  setup do
    {:ok, user: insert(:viewer), user1: insert(:streamer)}
  end

  describe "append_notice/2" do
    test "adds a new_follower notice to the user's notification queue", context do
      %{user: user, user1: user1} = context

      assert :ok = Notification.append_notice(user.id, %{from_id: user1.id, type: :new_follower})
    end

    test "adds a followee_is_live notice to the user's notification queue", context do
      %{user: user, user1: user1} = context

      assert :ok =
               Notification.append_notice(user.id, %{from_id: user1.id, type: :followee_is_live})
    end

    test "adds a new_message notice to the user's notification queue", context do
      %{user: user, user1: user1} = context
      content = Faker.Lorem.sentence()

      assert :ok =
               Notification.append_notice(user.id, %{
                 from_id: user1.id,
                 content: content,
                 type: :new_message
               })
    end

    test "adds a new_post notice to the user's notification queue", context do
      %{user: user, user1: user1} = context
      content = Faker.Lorem.sentence()

      assert :ok =
               Notification.append_notice(user.id, %{
                 from_id: user1.id,
                 content: content,
                 type: :new_post
               })
    end
  end

  describe "get_notices/1" do
    setup context do
      %{user: user} = context
      {:ok, notices: insert_list(15, :notice, user: user)}
    end

    test "gets a list of unread notices", context do
      %{user: user} = context

      result = Notification.get_notices(user.id)

      assert Enum.count(result) == 10

      assert Enum.reduce(result, fn
               n, nil ->
                 n

               n, acc ->
                 assert n.inserted_at < acc.inserted_at
                 n
             end)
    end

    test "can paginate", context do
      %{user: user} = context

      result = Notification.get_notices(user.id)
      result1 = Notification.get_notices(user.id, page: 2)

      refute result1 == result

      assert List.first(result1) |> Map.get(:inserted_at) <
               List.last(result) |> Map.get(:inserted_at)
    end
  end
end
