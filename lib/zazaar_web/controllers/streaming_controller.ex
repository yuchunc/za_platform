defmodule ZaZaarWeb.StreamingController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def show(conn, _params) do
    with %User{} = streamer <- current_resource(conn) do
      render(conn, "show.html", streamer_id: streamer.id)
    end
  end
end
