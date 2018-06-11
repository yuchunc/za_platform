defmodule ZaZaarWeb.UserChannel do
  use ZaZaarWeb, :channel

  require Logger

  def join("user:" <> user_id, _message, socket) do
    with %User{} = resource <- current_resource(socket),
         true <- user_id == resource.id do
      send(self(), :after_join)
      {:ok, socket}
    else
      _ -> {:error, :wrong_user}
    end
  end

  def handle_info(:after_join, socket) do
    broadcast(socket, "user:signed_in", %{})

    {:noreply, socket}
  end

  def handle_in("add_post", params, socket) do
    with user <- current_resource(socket),
         %{"content" => content} <- params,
         {:ok, post} <- Feed.add_post(user.id, content) do
      broadcast(socket, "post_added", %{post: post})

      {:noreply, socket}
    else
      _ -> {:error, :add_post_failed}
    end
  end
end
