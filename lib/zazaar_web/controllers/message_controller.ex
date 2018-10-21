defmodule ZaZaarWeb.MessageController do
  use ZaZaarWeb, :controller

  plug(:put_view, ZaZaarWeb.WhisperView)

  action_fallback(FallbackController)

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
