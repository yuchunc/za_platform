defmodule ZaZaar.FeedTest do
  use ZaZaar.DataCase

  alias ZaZaar.Feed
  alias Feed.Post

  setup do
    {:ok, user: insert(:user)}
  end

  describe "get_feed/1" do
    test "get a list of feeds for a user", context do
      %{user: user} = context
      count = 10
      insert_list(count, :post, user_id: user.id)

      result = Feed.get_feed(user.id)

      assert Enum.count(result) == count

      Enum.each(result, fn p -> assert p.user_id == user.id end)
    end
  end

  describe "add_post/2" do
    test "adds a post of the feed", context do
      %{user: user} = context

      assert {:ok, %Post{}} = Feed.add_post(user.id, "Founding is fucking hard")
    end
  end
end
