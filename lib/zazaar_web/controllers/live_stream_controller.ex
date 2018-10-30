defmodule ZaZaarWeb.LiveStreamController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def index(conn, _params) do
    with streams0 <- Streaming.get_streams(order_by: [desc: :archived_at, desc: :inserted_at]),
         streamer_ids <- Enum.map(streams0, & &1.streamer_id),
         users <- Account.get_users(streamer_ids),
         streams1 <- append_streamer(streams0, users) do
      render(conn, "index.html", streams: streams1)
    end
  end

  def show(conn, %{"id" => stream_id}) do
    with stream <- Streaming.get_stream(stream_id),
         comments <- include_user_names(stream.comments) do
      render(conn, "show.html", stream: stream, comments: comments)
    end
  end

  defp append_streamer(streams, users) do
    Enum.map(streams, fn stream ->
      user = Enum.find(users, &(&1.id == stream.streamer_id))
      Map.put_new(stream, :streamer, user)
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
