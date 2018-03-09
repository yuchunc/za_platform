defmodule OpenTok.OpenTokTest do
  @moduledoc """
  Tests the OpenTok Module
  """

  use ExUnit.Case, async: true

  @tag :skip
  describe "create_session/0" do
    test "creates a session from config" do
      assert {:ok, _session_id} = OpenTok.create_session
    end
  end

  @tag :skip
  describe "generate_toke/1" do
    test "generates some token from session_id" do
      {:ok, _session_id} = OpenTok.create_session

      assert {:ok, _some_token} = OpenTok.generate_token
    end
  end
end
