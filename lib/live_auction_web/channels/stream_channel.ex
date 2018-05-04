defmodule LiveAuctionWeb.StreamChannel do
  use LiveAuctionWeb, :channel

  def join("stream:" <> streamer_id, _message, socket) do
    send(self(), {:after_join, streamer_id})
    {:ok, socket}
  end

  def handle_info({:after_join, streamer_id}, socket) do
    payload =
      case current_resource(socket) do
        nil -> %{}
        user -> %{user: user}
      end

    if Streaming.current_stream_for(streamer_id) do
      broadcast(socket, "stream:joined", payload)
    end

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
      broadcast(socket, "stream:show_started", %{message: message})
      {:reply, {:ok, opentok_params}, socket}
    else
      _ ->
        render(ErrorView, "404.html", %{})
    end
  end

  def terminate(_reason, socket) do
    %{topic: "stream:" <> streamer_id} = socket

    case current_resource(socket) do
      nil -> broadcast!(socket, "stream:viewer_left", %{})
      %{id: uid} when uid == streamer_id -> broadcast!(socket, "stream:show_ended", %{})
      user -> broadcast!(socket, "stream:viewer_left", %{user: user})
    end

    :ok
  end
end
