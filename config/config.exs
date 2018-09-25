# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# fb_names = "name,email,first_name,last_name,middle_name,name_format,short_name"
# fb_info = "birthday,context,gender,profile_pic,security_settings,significant_other"
# fb_location = "address,hometown,language,location"

# General application configuration
config :zazaar, namespace: ZaZaarWeb, ecto_repos: [ZaZaar.Repo]

# Configures the endpoint
config :zazaar, ZaZaarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MOILzEC2RzH6h4ClnlxDe4tUNVuEH19jZeszWOpCDeWUX9BfNTGuaLYMDM4oswGh",
  render_errors: [view: ZaZaarWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZaZaar.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :zazaar, ZaZaar.Auth.Guardian,
  issuer: "zazaar",
  error_handler: ZaZaar.Auth.ErrorHandler,
  secret_key: "TLzXhQ2+gSqRNaEMvuZrWwkfHiNkkcAARlrh4iavEYA/RrQ6A896FtrxnUxn5Qpp",
  ttl: {30, :days},
  verify_issuer: true

config :guardian, Guardian.DB, repo: ZaZaar.Repo

config :zazaar, :ot_api, OpenTok.Api

config :phoenix_inline_svg,
  dir: "/priv/static/images",
  default_collection: "",
  not_found: "<p>Oh No!</p>"

config :ueberauth, Ueberauth,
  providers: [
    facebook:
      {Ueberauth.Strategy.Facebook,
       [
         profile_fields: "name,email,first_name,last_name",
         # profile_fields: fb_names <> fb_info <> fb_location,
         display: "popup"
       ]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
