defmodule ZaZaarWeb.LiveStreamController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def index(conn, _params) do
    with channels0 <- Streaming.get_channels(snapshot: true),
         streamer_ids <- Enum.map(channels0, & &1.streamer_id),
         users <- Account.get_users(streamer_ids),
         channels1 <- append_streamer(channels0, users) do
      render(conn, "index.html", channels: channels1)
    end
  end

  def show(conn, %{"id" => streamer_id}) do
    streamer = Account.get_user(streamer_id)

    comments =
      Streaming.get_active_stream(streamer_id)
      |> Map.get(:comments)
      |> include_user_names

    render(conn, "show.html", streamer: streamer, comments: comments)
  end

  defp append_streamer(channels, users) do
    Enum.map(channels, fn channel ->
      user = Enum.find(users, &(&1.id == channel.streamer_id))
      Map.put_new(channel, :streamer, user)
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
