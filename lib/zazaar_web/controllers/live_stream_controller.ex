defmodule ZaZaarWeb.LiveStreamController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  alias ZaZaarWeb.StreamPresence, as: Presence

  def index(conn, _params) do
    with streams0 <- Streaming.get_streams(order_by: [desc: :archived_at, desc: :inserted_at]),
         streamer_ids <- Enum.map(streams0, & &1.streamer_id),
         users <- Account.get_users(streamer_ids),
         streams1 <- append_info(streams0, users) do
      render(conn, "index.html", streams: streams1)
    end
  end

  def show(conn, %{"id" => stream_id}) do
    with stream0 <- Streaming.get_stream(stream_id),
         comments <- include_user_names(stream0.comments) do
      stream1 = Map.put(stream0, :comments, comments)
      user = current_resource(conn) || %User{}
      render(conn, "show.html", stream: stream1, user: user)
    end
  end

  defp append_info(streams, users) do
    Enum.map(streams, fn stream ->
      user = Enum.find(users, &(&1.id == stream.streamer_id))

      stream
      |> Map.put_new(:streamer, user)
      |> Map.put_new(:viewer_count, Presence.list("stream:" <> stream.id) |> Enum.count())
    end)
  end

  defp include_user_names(comments) do
    users =
      comments
      |> Enum.map(& &1.user_id)
      |> Enum.uniq()
      |> Account.get_users()

    Enum.map(comments, fn c ->
      name =
        users
        |> Enum.find(&(&1.id == c.user_id))
        |> Map.get(:name)

      Map.put(c, :user_name, name)
    end)
  end
end
