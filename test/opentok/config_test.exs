defmodule OpenTok.ConfigTest do
  @moduledoc """
  Test configuration
  """

  use ExUnit.Case

  import OpenTok.TestUtils

  alias OpenTok.Config

  describe "initialize/0" do
    test "throws error tuple when config is invalid" do
      assert {:error, :invalid_config} = Config.initialize()
    end

    test "minimum config from app configs" do
      stub_creds = %{
        key: "00000000",
        secret: "00000000000000000000000000000000"
      }

      assert with_config(stub_creds, fn() ->
        response = Config.initialize
        app_config = Application.get_env(:opentok, :config)
        assert app_config == Map.merge(stub_creds, default_configuration())
        response
      end) == :ok
    end
  end

  defp default_configuration() do
    %{
      env: Mix.env,
      endpoint: "https://api.opentok.com"
    }
  end
end
