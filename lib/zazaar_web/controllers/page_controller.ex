defmodule ZaZaarWeb.PageController do
  use ZaZaarWeb, :controller

  def privacy(conn, _attr) do
    render(conn, "privacy.html")
  end
end
