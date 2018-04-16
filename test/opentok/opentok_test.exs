defmodule OpenTok.OpenTokTest do
  @moduledoc """
  Tests the OpenTok Module
  """

  use ExUnit.Case, async: true

  import Mox

  setup :verify_on_exit!

  describe "request_session_id/1" do
    test "creates a session from config" do
      session_id =
        "1_MX40NjA3NDA1Mn5-MTUyMzg2Njg0NjIzN35LNjFOVkI3RWR6M2U3dUw4aXZyQ1hOU3B-fg"

      expect(OpenTok.ApiMock, :request_session_id, fn(_, _) ->
        {:ok, session_id}
      end)
      assert OpenTok.request_session_id == {:ok, session_id}
    end
  end

  @tag :skip
  describe "generate_token/4" do
    test "generates an valid token" do
      {:ok, session_id} = OpenTok.create_session

      assert {:ok, token} = OpenTok.generate_token(session_id, :publisher, "foobar")
      assert is_binary(token)
    end
  end

  @tag :skip
  describe "session_state/2" do
    test "monitors a session by session_id" do
      {:ok, session_id} = OpenTok.create_session

      assert {:ok, %HTTPoison.Response{}} = OpenTok.session_state(session_id)
    end
  end
end
