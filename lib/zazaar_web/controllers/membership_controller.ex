defmodule ZaZaarWeb.MembershipController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def show(conn, _) do
    render(conn, "dashboard.html")
  end
end
