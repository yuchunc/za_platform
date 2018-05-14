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

  def handle_in("stream:show_start", params, socket) do
    with %{"message" => message} <- params,
         %{topic: "stream:" <> streamer_id} <- socket,
         %User{} = streamer <- current_resource(socket),
         true <- streamer_id == streamer.id,
         {:ok, stream} <- Streaming.new_session(streamer.id),
         {:ok, key, token} <-
           OpenTok.generate_token(stream.ot_session_id, :publisher, streamer.id) do
      opentok_params = %{session_id: stream.ot_session_id, token: token, key: key}
      broadcast(socket, "streamer:show_started", %{message: message})
      {:reply, {:ok, opentok_params}, socket}
    else
      _ ->
        render(ErrorView, "404.html", %{})
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
