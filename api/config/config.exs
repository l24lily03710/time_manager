# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :time_manager,
  ecto_repos: [TimeManager.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :time_manager, TimeManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e2M3SdxCy27vsD3gN6ppHaI7JISfjQNJcRZuFsoPHN9/gxngb6vIumu4sZIunaXu",
  render_errors: [view: TimeManagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TimeManager.PubSub,
  live_view: [signing_salt: "SWNA36Bi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config cors thing
config :myapp, MyAppWeb.Endpoint,
  http: [port: 4000],
  cors: [
    origins: "*",
    methods: "GET, POST, PUT, DELETE, OPTIONS",
    headers: "authorization, content-type, accept",
    max_age: 0
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
