defmodule ZaZaar.FollowingTest do
  use ZaZaar.DataCase

  alias ZaZaar.Following

  describe "start_following/2" do
    setup do
      streamer = insert(:streamer)
      follower = insert(:viewer)

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

  @tag :skip
  describe "get_following/1" do
    test "gets a list of currently following user ids for a user" do
    end
  end

  @tag :skip
  describe "get_follower/1" do
    test "gets a list of followers for a user" do
    end
  end

  @tag :skip
  describe "stop_following/2" do
    test "user can stop following a user" do
    end

    test "if user is not following, it is fine" do
    end
  end
end
