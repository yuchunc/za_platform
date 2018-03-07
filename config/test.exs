use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_auction, LiveAuctionWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :live_auction, LiveAuction.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "live_auction_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
