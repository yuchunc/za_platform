defmodule OpenTokTest do
  @moduledoc """
  Tests the OpenTok Module
  """

  use ZaZaar.DataCase, async: true

  import Mox

  alias OpenTok.ApiMock, as: ApiMock

  setup :verify_on_exit!

  setup do
    session_id = "1_MX40NjA3NDA1Mn5-MTUy000000000000N35LNjFOVkI3RWR6M2U3dUw4aXZyQ1hOU3B-fg"

    expect(ApiMock, :request_session_id, fn _ ->
      {:ok, session_id}
    end)

    {:ok, session_id: session_id}
  end

  describe "request_session_id/1" do
    test "creates a session from config", context do
      assert OpenTok.request_session_id() == {:ok, context.session_id}
    end
  end

  describe "generate_token/4" do
    test "generates an valid token" do
      {:ok, session_id} = OpenTok.request_session_id()

      config =
        Application.get_env(:zazaar, OpenTok)
        |> Map.new()

      assert {:ok, key, token} = OpenTok.generate_token(session_id, :publisher, "foobar")
      assert key == config.key
      assert is_binary(token)
    end
  end

  describe "session_state/2" do
    test "session_id is active" do
      expect(ApiMock, :get_session_state, fn _, _ ->
        {:ok, :active}
      end)

      {:ok, session_id} = OpenTok.request_session_id()

      assert {:ok, :active} = OpenTok.session_state(session_id)
    end

    test "session_id is nohost" do
      expect(ApiMock, :get_session_state, fn _, _ ->
        {:ok, :nohost}
      end)

      {:ok, session_id} = OpenTok.request_session_id()

      assert {:ok, :nohost} = OpenTok.session_state(session_id)
    end

    test "session_id is inactive" do
      expect(ApiMock, :get_session_state, fn _, _ ->
        {:ok, :inactive}
      end)

      {:ok, session_id} = OpenTok.request_session_id()

      assert {:ok, :inactive} = OpenTok.session_state(session_id)
    end
  end

  describe "stream_to_facebook/3" do
    test "successfully stream to Facebook" do
      expect(ApiMock, :external_broadcast, fn _, _, _ ->
        :ok
      end)

      {:ok, session_id} = OpenTok.request_session_id()
      streamer = insert(:user)
      stream_key = "2066820000000027?s_ps=1&s_vt=api&a=ATg43wd400000000"

      assert OpenTok.stream_to_facebook(session_id, streamer.id, stream_key) == :ok
    end
  end

  describe "record/2" do
    test ":start, start recording a stream" do
      recording_id = Ecto.UUID.generate()

      expect(ApiMock, :start_recording, fn _, _ ->
        {:ok, %{"id" => recording_id}}
      end)

      {:ok, session_id} = OpenTok.request_session_id()

      assert OpenTok.record(:start, session_id) == {:ok, recording_id}
    end

    test ":stop, stop recording a stream" do
      expect(ApiMock, :stop_recording, fn _, _ ->
        :ok
      end)

      {:ok, _session_id} = OpenTok.request_session_id()

      assert OpenTok.record(:stop, Ecto.UUID.generate()) == :ok
    end
  end
end
