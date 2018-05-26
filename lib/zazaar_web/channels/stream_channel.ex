defmodule ZaZaarWeb.StreamChannel do
  use ZaZaarWeb, :channel

  require Logger

  alias ZaZaarWeb.StreamWatcher

  def join("stream:" <> streamer_id, _message, socket) do
    payload =
      case current_resource(socket) do
        %User{} = user -> %{user_id: user.id}
        nil -> %{}
      end

    if Streaming.get_channel(streamer_id) do
      send(self(), {:after_join, payload})
      {:ok, socket}
    else
      {:error, %{reason: "Stream does not exist"}}
    end
  end

  def handle_info({:after_join, payload}, socket) do
    broadcast(socket, "user:joined", payload)

    {:noreply, socket}
  end

  def handle_info({:take_snapshot, streamer}, socket) do
    {:ok, key} = Streaming.gen_snapshot_key(streamer.id)
    broadcast(socket, "streamer:take_snapshot", %{upload_key: key})
    Process.send_after(self(), {:take_snapshot, streamer}, 1_800_000)
    {:noreply, socket}
  end

  def handle_in("streamer:show_start", params, socket) do
    with %{"message" => message} <- params,
         %{topic: "stream:" <> streamer_id} <- socket,
         %User{} = streamer <- current_resource(socket),
         true <- streamer_id == streamer.id,
         %Channel{} = channel <- Streaming.get_channel(streamer.id),
         # TODO need to better handle starting a stream,
         # there is possible to start 2 unarchived stream
         {:ok, _stream} <- Streaming.start_stream(channel),
         {:ok, key, token} <-
           OpenTok.generate_token(channel.ot_session_id, :publisher, streamer.id),
         :ok <-
           StreamWatcher.monitor(:channels, self(), {__MODULE__, :streamer_left, [streamer_id]}),
         opentok_params <- %{session_id: channel.ot_session_id, token: token, key: key} do
      broadcast(socket, "streamer:show_started", %{message: message})
      send(self(), {:take_snapshot, streamer})
      {:reply, {:ok, opentok_params}, socket}
    end
  end

  def handle_in("streamer:upload_snapshot", params, socket) do
    with %{"upload_key" => key, "snapshot" => snapshot} <- params,
         %User{} = streamer <- current_resource(socket),
         channel <- Streaming.get_channel(streamer.id),
         :ok <- Streaming.update_snapshot(channel, key, snapshot) do
      {:reply, :ok, socket}
    end
  end

  def handle_in("viewer:join", _params, socket) do
    with %{topic: "stream:" <> streamer_id} <- socket,
         viewer <- current_resource(socket),
         %Channel{} = channel <- Streaming.get_channel(streamer_id),
         {:ok, key, token} <- OpenTok.generate_token(channel.ot_session_id, :subscriber),
         opentok_params <- %{session_id: channel.ot_session_id, token: token, key: key} do
      if is_nil(viewer) do
        broadcast(socket, "viewer:joined", %{})
      else
        broadcast(socket, "viewer:joined", %{id: viewer.id})
      end

      {:reply, {:ok, opentok_params}, socket}
    end
  end

  def handle_in("user:send_message", params, socket) do
    with %{"message" => message} <- params,
         viewer <- current_resource(socket),
         current_time <- NaiveDateTime.utc_now(),
         payload <- %{user_id: viewer.id, message: message, send_at: current_time} do
      broadcast(socket, "user:message_sent", payload)

      {:noreply, socket}
    end
  end

  def terminate(reason, socket) do
    %{topic: "stream:" <> streamer_id} = socket

    Logger.debug("> leave #{inspect(reason)}")

    user = current_resource(socket)

    case current_resource(socket) do
      nil ->
        broadcast!(socket, "viewer:left", %{})

      %{id: streamer_id} ->
        broadcast!(socket, "streamer:show_ended", %{})

      user ->
        broadcast!(socket, "viewer:left", %{user: user})
    end

    :ok
  end

  def streamer_left(streamer_id) do
    Streaming.end_stream(streamer_id)
  end
end
