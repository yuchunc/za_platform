defmodule OpenTok.OpenTokTest do
  @moduledoc """
  Tests the OpenTok Module
  """

  use ExUnit.Case, async: true

  describe "create_session/1" do
    test "creates a session from config" do
      assert {:ok, session_id} = OpenTok.create_session
      assert String.match?(session_id, ~r/^\d_\w{15}-\w{51}-\w{2}$/)
    end
  end

  describe "generate_token/4" do
    test "generates an valid token" do
      {:ok, session_id} = OpenTok.create_session

      assert {:ok, token} = OpenTok.generate_token(session_id, :publisher, "foobar")
      assert is_binary(token)
    end
  end

  describe "session_state/2" do
    test "monitors a session by session_id" do
      {:ok, session_id} = OpenTok.create_session

      assert {:ok, %HTTPoison.Response{}} = OpenTok.session_state(session_id)
    end
  end
end
