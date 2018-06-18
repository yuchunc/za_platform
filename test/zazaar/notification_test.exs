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

  @tag :skip
  describe "get_notices/1" do
    test "gets a list of notices" do
    end

    test "can paginate" do
    end
  end

  describe "last_checked/1" do
    test "get the last open timestamp" do
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
