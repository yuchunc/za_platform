defmodule OpenTok.ApiTest do
  use LiveAuctionWeb.ConnCase, async: true

  alias OpenTok.Util

  @moduletag :ot_api

  @ot_confg OpenTok.Config.get_config

  describe "request_session_id/2" do
    test "sends error with back information" do
      assert {:error, _} = OpenTok.Api.request_session_id([], @ot_confg)
    end

    test "creates and sends back a session_id" do
      header = @ot_confg
               |> Util.generate_jwt
               |> Util.wrap_request_header

      assert {:ok, session_id} = OpenTok.Api.request_session_id(header, @ot_confg)
      assert String.match?(session_id, ~r/^\d_\w{15}-\w{51}-\w{2}$/)
    end
  end
end
