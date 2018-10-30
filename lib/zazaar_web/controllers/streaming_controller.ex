defmodule ZaZaarWeb.StreamingController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def create(conn, _params) do
    with streamer <- current_resource(conn),
         {:ok, stream} <- Streaming.start_stream(streamer.id) |> IO.inspect(label: "label") do
      redirect(conn, to: membership_streaming_path(conn, :show, stream.id))
    else
      {:error, :another_stream_is_active, stream_id} ->
        conn
        |> put_flash(:warning, "您已經在直播囉！")
        |> redirect(to: live_stream_path(conn, :show, stream_id))
    end
  end

  def show(conn, %{"id" => stream_id}) do
    render(conn, "show.html", stream_id: stream_id)
  end
end
