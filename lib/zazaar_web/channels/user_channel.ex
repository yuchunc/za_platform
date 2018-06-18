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

  # TODO Event to follow another User
  # Cannot follow self
  # broadcast to notify the other person you got a subscriber

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

  def handle_in("chat:history", params, socket) do
    with user <- current_resource(socket),
         %{"user_id" => user1_id} <- params,
         page <- Map.get(params, "page", 1),
         chats <- ChatLog.get_history([user.id, user1_id], page: page) do
      {:reply, {:ok, %{chats: chats}}, socket}
    else
      _ -> {:stop, :cannot_get_chat_log, socket}
    end
  end

  def handle_in("chat:send_message", params, socket) do
    with %{"to_id" => to_id, "body" => body} <- params,
         user <- current_resource(socket),
         msg <- %{user_id: user.id, body: body},
         payload <- Map.put_new(params, "from_id", user.id) do
      ZaZaarWeb.Endpoint.broadcast("user:" <> to_id, "chat:receive_message", payload)
      ChatLog.append_message([to_id, user.id], msg)

      {:reply, :ok, socket}
    else
      _ -> {:stop, :cannot_send_message, socket}
    end
  end

  def handle_in("chat:receive_message", params, socket) do
    %{"from_id" => from_id, "body" => body} = params
    broadcast(socket, "chat:received_message", %{from_id: from_id, body: body})
    {:noreply, socket}
  end

  def handle_in("notify:new_notice", params, socket) do
    {type, payload} = Map.pop(params, "type")
    user = current_resource(socket)
    Notification.append_notice(user.id, params)
    broadcast(socket, "notify:" <> Atom.to_string(type), payload)
    {:noreply, socket}
  end
end
