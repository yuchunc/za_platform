defmodule ZaZaarWeb.UserChannel do
  use ZaZaarWeb, :channel

  require Logger

  def join("user:" <> user_id, _message, socket) do
    with %User{} = resource <- current_resource(socket),
         true <- user_id == resource.id do
      send(self(), {:after_join, user_id})
      {:ok, socket}
    else
      _ -> {:error, :wrong_user}
    end
  end

  def handle_info({:after_join, user_id}, socket) do
    broadcast(socket, "user:signed_in", %{})

    {:noreply, socket}
  end
end
