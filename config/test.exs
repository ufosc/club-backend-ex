use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :club_backend, ClubBackend.Repo,
  username: System.get_env("PGUSER", "postgres"),
  password: System.get_env("PGPASSWORD", "postgres"),
  database: "club_backend_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("PGHOST", "localhost"),
  port: System.get_env("PGPORT", "5432") |> String.to_integer(),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :club_backend, ClubBackendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :cors_plug,
  origin: ["*"],
  max_age: 86_400,
  methods: ["GET", "POST"]
