defmodule ZaZaar.FeedTest do
  use ZaZaar.DataCase

  alias ZaZaar.Feed

  setup do
    {:ok, user: insert(:streamer)}
  end

  describe "get_feed/1" do
    test "get a list of feeds for a user", context do
      %{user: user} = context
      count = 10
      insert_list(count, :post, user_id: user.id)

      result = Feed.get_feed(user.id)

      assert Enum.count(result) == count
      Enum.each(result, fn p -> assert p.user_id == user.id end)
      assert (result |> List.first |> Map.get(:inserted_at))
        > (result |> List.last |> Map.get(:inserted_at))
    end
  end
end
