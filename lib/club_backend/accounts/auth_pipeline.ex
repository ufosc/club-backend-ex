defmodule ClubBackend.Accounts.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :club_backend,
    module: ClubBackend.Guardian,
    error_handler: ClubBackend.Accounts.ErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
