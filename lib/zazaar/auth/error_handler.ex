defmodule ZaZaar.Auth.ErrorHandler do
  use ZaZaarWeb, :controller

  def auth_error(conn, _, _opts) do
    redirect(conn, to: session_path(conn, :show))
  end
end
