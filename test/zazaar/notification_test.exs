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

      {:ok, notices: insert_notices(user)}
    end

    test "gets a list of unread notices", context do
      %{user: user} = context

      result = Notification.get_notices(user.id)

      assert Enum.count(result) == 15
    end
  end

  describe "count_notices/1" do
    setup context do
      %{user: user} = context

      {:ok, notices: insert_notices(user)}
    end

    test "get the count of the user notices", context do
      %{user: user} = context

      assert 15 = Notification.get_count(user.id)
    end
  end

  defp insert_notices(user, count \\ 15) do
    notices =
      1..count
      |> Enum.reduce([], fn _, acc ->
        notice_type = Enum.random(NoticeSchemaEnum.__enum_map__())
        [build(notice_type) | acc]
      end)

    Agent.update(Notification.Notice, fn state ->
      Map.put(state, user.id, notices)
    end)

    notices
  end
end
