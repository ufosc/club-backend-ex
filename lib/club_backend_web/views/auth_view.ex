defmodule ClubBackendWeb.AuthView do
  use ClubBackendWeb, :view

  def render("login.json", %{token: token} = _params) do
    %{token: token}
  end

  def render("login.error.json", _) do
    %{message: "Unknown username or password."}
  end

  def render("register.json", %{token: token}) do
    %{token: token}
  end

  def render("registration.error.json", %{changeset: %Ecto.Changeset{} = changeset}) do
    %{
      errors:
        Enum.map(
          changeset.errors,
          fn e ->
            {field, {msg, _}} = e
            %{field => msg}
          end
        )
    }
  end

  def render("registration.error.json", _) do
    %{errors: [message: "unknown error occurred during registration"]}
  end
end
