defmodule ZaZaarWeb.StreamChannel do
  use ZaZaarWeb, :channel

  def join("stream:" <> streamer_id, _message, socket) do
    payload =
      case current_resource(socket) do
        %User{} = user -> %{user_id: user.id}
        nil -> %{}
      end

    if Streaming.current_channel_for(streamer_id) do
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

  def handle_in("streamer:show_start", params, socket) do
    with %{"message" => message} <- params,
         %{topic: "stream:" <> streamer_id} <- socket,
         %User{} = streamer <- current_resource(socket),
         true <- streamer_id == streamer.id,
         %Channel{} = channel <- Streaming.current_channel_for(streamer.id),
         {:ok, _stream} <- Streaming.start_stream(channel),
         {:ok, key, token} <-
           OpenTok.generate_token(channel.ot_session_id, :publisher, streamer.id),
         opentok_params <- %{session_id: channel.ot_session_id, token: token, key: key} do
      broadcast(socket, "streamer:show_started", %{message: message})
      {:reply, {:ok, opentok_params}, socket}
    end
  end

  def handle_in("viewer:join", _params, socket) do
    with %{topic: "stream:" <> streamer_id} <- socket,
         viewer <- current_resource(socket),
         %Channel{} = channel <- Streaming.current_channel_for(streamer_id),
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

  def terminate(_reason, socket) do
    %{topic: "stream:" <> streamer_id} = socket

    case current_resource(socket) do
      nil -> broadcast!(socket, "viewer:left", %{})
      %{id: uid} when uid == streamer_id -> broadcast!(socket, "streamer:show_ended", %{})
      user -> broadcast!(socket, "viewer:left", %{user: user})
    end

    :ok
  end
end
