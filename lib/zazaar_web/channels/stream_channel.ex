defmodule ZaZaarWeb.StreamChannel do
  use ZaZaarWeb, :channel

  require Logger

  alias ZaZaarWeb.StreamPresence, as: Presence

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
      {:error, %{reason: :channel_not_found}}
    end
  end

  def handle_info({:after_join, payload}, socket) when payload == %{} do
    broadcast(socket, "user:joined", payload)

    Presence.track(socket, "anom:" <> Ecto.UUID.generate(), %{
      online_at: inspect(System.system_time(:seconds))
    })

    {:noreply, socket}
  end

  def handle_info({:after_join, payload}, socket) do
    broadcast(socket, "user:joined", payload)
    Presence.track(socket, payload.user_id, %{online_at: inspect(System.system_time(:seconds))})
    {:noreply, socket}
  end

  def handle_info({:take_snapshot, streamer}, socket) do
    {:ok, key} = Streaming.gen_snapshot_key(streamer.id)
    broadcast(socket, "streamer:take_snapshot", %{upload_key: key})
    Process.send_after(self(), {:take_snapshot, streamer}, 1_000 * 60 * 10)
    {:noreply, socket}
  end

  def handle_info({:start_recording, stream, session_id}, socket) do
    {:ok, recording_id} = OpenTok.record(:start, session_id)
    Streaming.update_stream(stream, %{recording_id: recording_id})

    {:noreply, socket}
  end

  def handle_in("streamer:show_start", params, socket) do
    with %{"message" => message} <- params,
         %{topic: "stream:" <> streamer_id} <- socket,
         %User{} = streamer <- current_resource(socket),
         true <- streamer_id == streamer.id,
         # TODO need to revisit L59
         channel <- Streaming.get_channel(streamer.id),
         {:ok, stream} <- Streaming.start_stream(channel),
         {:ok, key, token} <-
           OpenTok.generate_token(channel.ot_session_id, :publisher, streamer.id),
         opentok_params <- %{session_id: channel.ot_session_id, token: token, key: key} do
      broadcast(socket, "streamer:show_started", %{message: message})

      {:ok, _} =
        Presence.update(socket, streamer_id, %{
          streamer: true,
          online_at: inspect(System.system_time(:seconds))
        })

      streamer
      |> Following.get_followers()
      |> Enum.map(&Map.get(&1, :follower_id))
      |> Notification.append_notice(%{type: :followee_is_live, from_id: streamer.id})

      Process.send_after(self(), {:take_snapshot, streamer}, 1_000 * 2)
      Process.send_after(self(), {:start_recording, stream, channel.ot_session_id}, 1_000 * 2)

      {:reply, {:ok, opentok_params}, socket}
    end
  end

  def handle_in("streamer:upload_snapshot", params, socket) do
    with %{"upload_key" => key, "snapshot" => snapshot} <- params,
         %User{} = streamer <- current_resource(socket),
         # TODO revisit L88
         channel <- Streaming.get_channel(streamer.id),
         %Stream{} = stream <- Streaming.get_active_stream(channel) do
      if is_nil(stream.video_snapshot) do
        Streaming.stream_to_facebook(channel)
      end

      Streaming.update_snapshot(stream, key, snapshot)
      {:noreply, socket}
    end
  end

  def handle_in("viewer:join", _params, socket) do
    with %{topic: "stream:" <> streamer_id} <- socket,
         viewer <- current_resource(socket),
         # TODO revisit L103
         channel <- Streaming.get_channel(streamer_id),
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

  def handle_in("stream:send_comment", params, socket) do
    with %{"comment" => content} <- params,
         "stream:" <> streamer_id <- socket.topic,
         %Stream{} = stream <- Streaming.get_active_stream(streamer_id),
         user <- current_resource(socket),
         params <- %{user_id: user.id, content: content},
         {:ok, comment} <- Streaming.append_comment(stream, params) do
      broadcast(socket, "stream:comment_sent", %{user_name: user.name, comment: comment})
      {:noreply, socket}
    else
      _ -> {:reply, {:error, %{message: "failed comment"}}, socket}
    end
  end

  def terminate(_reason, socket) do
    user = current_resource(socket)
    archive_stream(socket.topic, user)
    # TODO stop OpenTok archiving
    :ok
  end

  defp archive_stream("stream:" <> streamer_id, %{id: streamer_id}) do
    Streaming.end_stream(streamer_id)
  end

  defp archive_stream(_, _), do: nil
end
