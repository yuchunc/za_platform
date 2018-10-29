defmodule ZaZaarWeb.StreamingController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def create(conn, _params) do
    with streamer <- current_resource(conn),
         {:ok, stream} <- Streaming.start_stream(streamer.id) do
      redirect(conn, to: membership_streaming_path(:show, id: stream.id))
    else
      {:error, :another_stream_is_active, stream_id} ->
        redirect(conn, to: live_stream_path(:show, id: stream_id))
    end
  end

  def show(conn, %{"id" => stream_id}) do
    render(conn, "show.html", stream_id: stream_id)
  end
end
