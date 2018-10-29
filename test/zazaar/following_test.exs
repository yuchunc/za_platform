defmodule ZaZaar.FollowingTest do
  use ZaZaar.DataCase

  alias ZaZaar.Following

  describe "start_following/2" do
    setup do
      streamer = insert(:user)
      follower = insert(:user)

      {:ok, streamer: streamer, follower: follower}
    end

    test "user can follow another user", context do
      %{streamer: streamer, follower: follower} = context

      assert Following.start_following(follower, streamer) == :ok
    end

    test "if user is already following, it is fine", context do
      %{streamer: streamer, follower: follower} = context

      assert Following.start_following(follower, streamer) == :ok
      assert Following.start_following(follower, streamer) == :ok
    end

    test "user cannot follow her self", context do
      %{streamer: streamer} = context

      assert Following.start_following(streamer, streamer) == {:error, :cannot_follow_self}
    end
  end

  describe "get_following/1" do
    test "gets a list of currently following user ids for a user" do
      follower = insert(:user)
      follows = insert_pair(:follow, follower_id: follower.id)

      result = Following.get_followings(follower)

      assert result |> Enum.map(& &1.id) |> Enum.sort() ==
               follows |> Enum.map(& &1.id) |> Enum.sort()
    end
  end

  describe "get_follower/1" do
    test "gets a list of followers for a user" do
      followee = insert(:user)
      follows = insert_pair(:follow, followee_id: followee.id)

      result = Following.get_followers(followee)

      assert result |> Enum.map(& &1.id) |> Enum.sort() ==
               follows |> Enum.map(& &1.id) |> Enum.sort()
    end
  end

  describe "stop_following/2" do
    setup do
      {:ok, follow: insert(:follow)}
    end

    test "user can stop following a user", context do
      %{follow: follow} = context

      assert Following.stop_following(%{id: follow.follower_id}, %{id: follow.followee_id}) == :ok
    end

    test "if user is not following, it is fine" do
      assert Following.stop_following(insert(:user), insert(:user)) == :ok
    end
  end
end
