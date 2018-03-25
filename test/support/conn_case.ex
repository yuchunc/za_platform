defmodule LiveAuctionWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  import LiveAuction.Factory
  import Plug.Conn
  import Phoenix.ConnTest

  alias LiveAuction.Auth.Guardian

  @endpoint LiveAuctionWeb.Endpoint

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import LiveAuctionWeb.Router.Helpers
      import LiveAuction.Factory

      # The default endpoint for testing
      @endpoint LiveAuctionWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(LiveAuction.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(LiveAuction.Repo, {:shared, self()})
    end

    user = insert(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, %{})

    conn = Phoenix.ConnTest.build_conn()
           |> bypass_through(LiveAuctionWeb.Router, :browser)
           |> get("/")
           |> put_session("auth", token)
           |> send_resp(:ok, "")

    {:ok, conn: conn, user: user}
  end

end
