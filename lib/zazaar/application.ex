defmodule ZaZaar.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(ZaZaar.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ZaZaarWeb.Endpoint, []),
      supervisor(ZaZaarWeb.StreamPresence, []),
      worker(Guardian.DB.Token.SweeperServer, []),
      worker(ZaZaar.Notification.Notice, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ZaZaar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ZaZaarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
