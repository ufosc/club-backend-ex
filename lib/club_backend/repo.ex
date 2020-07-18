defmodule ClubBackend.Repo do
  use Ecto.Repo,
    otp_app: :club_backend,
    adapter: Ecto.Adapters.Postgres
end
