defmodule ZaZaarWeb.SigChannel do
  use Phoenix.Channel

  def join("call", _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("message", payload, socket) do
    broadcast_from socket, "message", payload
    {:noreply, socket}
  end
end
