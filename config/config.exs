# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :exrush, ExrushWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qn68iLVTUcdTAeCD0lelSs7ILCaL6WmCi1tgOsWB1JjZukH3tlutkPW9TXqNrCJa",
  render_errors: [view: ExrushWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Exrush.PubSub,
  live_view: [signing_salt: "zA43PxOv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# JSON file path
config :exrush, json_path: "priv/rushing.json"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
