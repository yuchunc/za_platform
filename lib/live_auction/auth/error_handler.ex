defmodule LiveAuction.Auth.ErrorHandler do
  use LiveAuctionWeb, :controller

  def auth_error(conn, foo, _opts) do
    conn |> IO.inspect(label: "bad conn")
    foo |> IO.inspect(label: "reasons")
    redirect(conn, to: page_path(conn, :index))
  end
end
