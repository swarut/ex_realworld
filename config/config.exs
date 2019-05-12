# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ex_realworld,
  ecto_repos: [ExRealworld.Repo]

# Configures the endpoint
config :ex_realworld, ExRealworldWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vGK2g6sAB0SRDwu0bPEzPfoMbeRaqPb8JMnx2G2OPpBkqLJiV0wsZ2mGPD+o3X9k",
  render_errors: [view: ExRealworldWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExRealworld.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
