defmodule OpenTok.OpenTokTest do
  @moduledoc """
  Tests the OpenTok Module
  """

  use ExUnit.Case, async: true

  describe "create_session/0" do
    test "creates a session from config" do
      assert {:ok, session_id} = OpenTok.create_session
      assert is_binary(session_id)
      assert String.match?(session_id, ~r/^\d_\w{15}-\w{51}-\w{2}$/)
    end
  end
end
