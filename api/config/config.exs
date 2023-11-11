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
  secret_key_base: "ibRCIm3Vo2g1sOXk3wYfuKaRHdAx/H5KYdgzc7P955jQrGZDOXAENY2Ce4m6N4oG",
  render_errors: [view: TimeManagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TimeManager.PubSub,
  live_view: [signing_salt: "jhRT3NlY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config cors thing
config :time_manager, TimeManagerWeb.Endpoint,
  http: [port: 4000],
  cors: [
    origins: "http://localhost:8080",
    methods: "GET, POST, PUT, DELETE, OPTIONS",
    headers: "authorization, content-type, accept",
    max_age: 0
  ]

config :time_manager, TimeManager.Guardian,
  issuer: "time_manager",
  secret_key: "yHAwBrlhtX4ODoD7/KBgHKcYa8cRlqtxcfmt/Uf+6PeqECxjRbT8dCKpTvGvajuN"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
