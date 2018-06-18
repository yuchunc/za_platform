defmodule ZaZaar.NotificationTest do
  use ZaZaar.DataCase

  alias ZaZaar.Notification

  setup do
    {:ok, user: insert(:viewer), user1: insert(:streamer)}
  end

  describe "append_notice/2" do
    test "adds a new_follower notice to the user's notification queue", context do
      %{user: user, user1: user1} = context

      assert {:ok, notice} =
               Notification.append_notice(:new_follower, user.id, %{from_id: user1.id})

      assert notice.user_id == user.id
      assert notice.schema.from_id == user1.id
    end

    test "adds a followee_is_live notice to the user's notification queue", context do
      %{user: user, user1: user1} = context

      assert {:ok, notice} =
               Notification.append_notice(:followee_is_live, user.id, %{from_id: user1.id})

      assert notice.user_id == user.id
      assert notice.schema.from_id == user1.id
    end

    test "adds a new_message notice to the user's notification queue", context do
      %{user: user, user1: user1} = context
      content = Faker.Lorem.sentence()

      assert {:ok, notice} =
               Notification.append_notice(:new_message, user.id, %{
                 from_id: user1.id,
                 content: content
               })

      assert notice.user_id == user.id
      assert notice.schema.from_id == user1.id
      assert notice.schema.content == content
    end

    test "adds a new_post notice to the user's notification queue", context do
      %{user: user, user1: user1} = context
      content = Faker.Lorem.sentence()

      assert {:ok, notice} =
               Notification.append_notice(:new_post, user.id, %{
                 from_id: user1.id,
                 content: content
               })

      assert notice.user_id == user.id
      assert notice.schema.from_id == user1.id
      assert notice.schema.content == content
    end
  end

  describe "get_notices/1" do
    setup context do
      %{user: user} = context
      {:ok, notices: insert_list(15, :notice, user: user)}
    end

    test "gets a list of notices", context do
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

  describe "last_checked/1" do
    test "get the last open timestamp" do
      user = insert(:viewer)

      assert %NaiveDateTime{} = Notification.last_checked(user.id)
    end
  end

  describe "check/1" do
    test "record the last time the notification was checked" do
      user = insert(:viewer)

      assert {:ok, %NaiveDateTime{} = time} = Notification.check(user.id)
      {:ok, %NaiveDateTime{} = time1} = Notification.check(user.id)

      assert time1 > time
    end
  end
end
