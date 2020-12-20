# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

config :club_backend, ClubBackend.Repo,
  # ssl: true,
  username: System.get_env("DBUSER", "postgres"),
  password: System.get_env("DBPASSWORD", "postgres"),
  database: "club_backend_prod",
  hostname: System.get_env("DBHOST", "localhost"),
  port: System.get_env("DBPORT", "5432") |> String.to_integer(),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env!("SECRET_KEY_BASE")

config :club_backend, ClubBackendWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :club_backend, ClubBackendWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
