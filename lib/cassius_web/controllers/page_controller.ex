defmodule CassiusWeb.PageController do
  use CassiusWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
