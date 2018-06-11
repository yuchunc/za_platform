defmodule OpenTok.ApiTest do
  use ZaZaar.DataCase, async: true

  alias OpenTok.Util

  @moduletag :ot_api

  @ot_config Util.get_config()

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
    setup do
      headers = create_session_headers(@ot_config)
      {:ok, session_id} = OpenTok.Api.request_session_id(headers)

      {:ok, headers: headers, session_id: session_id}
    end

    test "no active stream_id", context do
      %{headers: headers, session_id: session_id} = context

      assert OpenTok.Api.get_session_state(session_id, headers) == {:ok, :inactive}
    end

    @tag :skip
    test "has active stream_id", context do
      %{headers: headers} = context
      session_id = "some session_id"

      {:ok, %{"count" => _, "items" => _}} = OpenTok.Api.get_session_state(session_id, headers)
    end
  end

  describe "external_broadcast/2" do
    setup do
      headers = create_session_headers(@ot_config)

      {:ok, session_id} = OpenTok.Api.request_session_id(headers)
      facebook_key = "2066820000000027?s_ps=1&s_vt=api&a=ATg43wd400000000"
      channel = insert(:channel,
                       facebook_key: facebook_key,
                       ot_session_id: session_id)

      {:ok, headers: headers, channel: channel}
    end

    test "broadcasts to external services", context do
      %{headers: headers, channel: channel} = context

      session_id = channel.ot_session_id
      rtmp_list = [Util.build_facebook_rtmp(channel)]

      assert OpenTok.Api.external_broadcast(session_id, headers, rtmp_list) == {:error, :noclient}
    end
  end

  # TODO stop broadcasting

  defp create_session_headers(config) do
    config
    |> Util.generate_jwt()
    |> Util.wrap_request_headers()
  end
end
