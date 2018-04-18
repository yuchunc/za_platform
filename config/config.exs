# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :live_auction,
  ecto_repos: [LiveAuction.Repo]

# Configures the endpoint
config :live_auction, LiveAuctionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MOILzEC2RzH6h4ClnlxDe4tUNVuEH19jZeszWOpCDeWUX9BfNTGuaLYMDM4oswGh",
  render_errors: [view: LiveAuctionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveAuction.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :live_auction, LiveAuction.Auth.Guardian,
  issuer: "live_auction",
  error_handler: LiveAuction.Auth.ErrorHandler

config :guardian, Guardian.DB,
  repo: LiveAuction.Repo

config :live_auction, :ot_api, OpenTok.Api

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
