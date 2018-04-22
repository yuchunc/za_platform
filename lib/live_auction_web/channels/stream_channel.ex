defmodule LiveAuctionWeb.StreamChannel do
  use LiveAuctionWeb, :channel

  def join("stream:" <> streamer_id, _message, socket) do
    send(self(), {:after_join, streamer_id})
    {:ok, socket}
  end

  def handle_info({:after_join, streamer_id}, socket) do
    payload = case current_resource(socket) do
      nil -> %{}
      user -> %{user: user}
    end
    broadcast!(socket, "stream:#{streamer_id}:joined", payload)
    {:noreply, socket}
  end
end
