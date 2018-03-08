defmodule OpenTok.OpenTokTest do
  @moduledoc """
  Tests the OpenTok Module
  """

  use ExUnit.Case, async: true

  @tag :skip
  describe "create_session/0" do
    test "creates a session from config" do
      assert OpenTok.create_session
      |> IO.inspect(label: "session")
    end
  end
end
