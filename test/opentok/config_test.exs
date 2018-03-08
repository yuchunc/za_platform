defmodule OpenTok.ConfigTest do
  @moduledoc """
  Test configuration
  """

  use ExUnit.Case

  import OpenTok.TestUtils

  alias OpenTok.Config

  describe "initialize/0" do
    test "throws error tuple when key is empty" do
      stub_creds = %{
        key: nil
      }
      assert {:error, :invalid_config} = with_config(stub_creds, &Config.initialize/0)
    end

    test "throws error tuple when secret is empty" do
      stub_creds = %{
        secret: nil
      }
      assert {:error, :invalid_config} = with_config(stub_creds, &Config.initialize/0)
    end

    test "minimum config from app configs" do
      stub_creds = %{
        key: "00000000",
        secret: "00000000000000000000000000000000"
      }

      assert with_config(stub_creds, fn() ->
        response = Config.initialize
        app_config = Application.get_env(:live_auction, OpenTok) |> Map.new
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
