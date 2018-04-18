defmodule OpenTok.ApiTest do
  use LiveAuctionWeb.ConnCase, async: true

  alias OpenTok.Util

  @moduletag :ot_api

  @ot_config Util.get_config

  describe "request_session_id/1" do
    test "sends error with back information" do
      assert {:error, _} = OpenTok.Api.request_session_id([])
    end

    test "creates and sends back a session_id" do
      headers = create_session_headers(@ot_config)

      assert {:ok, session_id} = OpenTok.Api.request_session_id(headers)
      assert String.match?(session_id, ~r/^\d_\w{15}-\w{51}-\w{2}$/)
    end
  end

  describe "get_session_state/1" do
    test "gets the current state of the given session id" do
      headers = create_session_headers(@ot_config)

      {:ok, session_id} = OpenTok.Api.request_session_id(headers)

      OpenTok.Api.get_session_state(session_id, headers)
      |> IO.inspect(label: "label")
    end
  end

  defp create_session_headers(config) do
    config
    |> Util.generate_jwt
    |> Util.wrap_request_headers
  end
end
