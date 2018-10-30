defmodule ZaZaarWeb.StreamChannel do
  use ZaZaarWeb, :channel

  require Logger

  alias ZaZaarWeb.StreamPresence, as: Presence

  def join("stream:" <> stream_id, _message, socket) do
    payload =
      case current_resource(socket) do
        %User{} = user -> %{user_id: user.id}
        nil -> %{}
      end

    if Streaming.get_stream(stream_id) do
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

  def handle_in("streamer:show_start", params, socket0) do
    with %{"message" => message} <- params,
         %{topic: "stream:" <> stream_id} <- socket0,
         %User{} = streamer <- current_resource(socket0),
         stream <- Streaming.get_stream(stream_id),
         true <- stream.streamer_id == streamer.id,
         {:ok, key, token} <-
           OpenTok.generate_token(streamer.ot_session_id, :publisher, stream.id),
         opentok_params <- %{session_id: streamer.ot_session_id, token: token, key: key} do
      socket1 = assign(socket0, :role, :streamer)
      broadcast(socket0, "streamer:show_started", %{message: message})

      {:ok, _} =
        Presence.update(socket1, streamer.id, %{
          streamer: true,
          online_at: inspect(System.system_time(:seconds))
        })

      streamer
      |> Following.get_followers()
      |> Enum.map(&Map.get(&1, :follower_id))
      |> Notification.append_notice(%{type: :followee_is_live, from_id: streamer.id})

      Process.send_after(self(), {:take_snapshot, streamer}, 1_000 * 2)
      Process.send_after(self(), {:start_recording, stream, streamer.ot_session_id}, 1_000 * 2)

      {:reply, {:ok, opentok_params}, socket1}
    end
  end

  def handle_in("streamer:upload_snapshot", params, socket) do
    with %{"upload_key" => key, "snapshot" => snapshot} <- params,
         "stream:" <> stream_id <- socket.topic,
         stream <- Streaming.get_stream(stream_id) do
      # TODO need a better way to handle facebook broadcast
      # if is_nil(stream.video_snapshot) do
      # Streaming.stream_to_facebook(stream, stream.fb_stream_key, streamer.ot_session_id)
      # end

      Streaming.update_snapshot(stream, key, snapshot)
      {:noreply, socket}
    end
  end

  def handle_in("viewer:join", _params, socket0) do
    with %{topic: "stream:" <> stream_id} <- socket0,
         viewer <- current_resource(socket0),
         streamer <-
           Streaming.get_stream(stream_id) |> Map.get(:streamer_id) |> Account.get_user(),
         {:ok, key, token} <- OpenTok.generate_token(streamer.ot_session_id, :subscriber),
         opentok_params <- %{session_id: streamer.ot_session_id, token: token, key: key} do
      socket1 = assign(socket0, :role, :viewer)

      if is_nil(viewer) do
        broadcast(socket1, "viewer:joined", %{})
      else
        broadcast(socket1, "viewer:joined", %{id: viewer.id})
      end

      {:reply, {:ok, opentok_params}, socket1}
    end
  end

  def handle_in("stream:send_comment", params, socket) do
    with %{"comment" => content} <- params,
         "stream:" <> stream_id <- socket.topic,
         %Stream{} = stream <- Streaming.get_stream(stream_id),
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
    if socket.assigns[:role] == :streamer do
      "stream:" <> stream_id = socket.topic
      Streaming.end_stream(stream_id)
    end

    :ok
  end
end
