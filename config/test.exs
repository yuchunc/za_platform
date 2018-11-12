use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zazaar, ZaZaarWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :zazaar, ZaZaar.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "zazaar_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :zazaar, ZaZaar.Auth.Guardian,
  secret_key: "prny2TAQ3ETSsfPaelwWTs2/9EyxKKGqH32i4VV2HfEnTXM8KFhib6XDUEvmpXs3"

config :argon2_elixir, t_cost: 1, m_cost: 8

config :zazaar, :ot_api, OpenTok.ApiMock

config :zazaar, :fb_api, Facebook.GraphApiMock

import_config "test.secret.exs"
