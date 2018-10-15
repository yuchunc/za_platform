defmodule ZaZaarWeb.MessageController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
