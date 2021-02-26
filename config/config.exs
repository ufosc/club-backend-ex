# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :club_backend,
  ecto_repos: [ClubBackend.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :club_backend, ClubBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "feZGb83oV6EJqe9zBEF5j93YSVSvSvTTStRAEk6r0NAe2orWcVqIlyGdgggLn9lN",
  render_errors: [view: ClubBackendWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ClubBackend.PubSub,
  live_view: [signing_salt: "0ds4u0wH"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :club_backend, ClubBackend.Guardian,
  issuer: "club_backend",
  secret_key: "NWR7fU0ul5tv9p81Y2gOCXAiyVZ3Xu4+hK4C1K6TCy+w3LngISV+VL+x7e4LCTgT"

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
