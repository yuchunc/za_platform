defmodule ZaZaarWeb.FallbackController do
  use ZaZaarWeb, :controller

  alias ZaZaarWeb.ErrorView

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> render(ErrorView, "401.html")
  end

  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, "404.html")
  end
end
