defmodule ClubBackendWeb.AuthView do
  use ClubBackendWeb, :view

  def render("login.json", %{user: user} = _params) do
    %{username: user.username}
  end

  def render("login.error.json", _) do
    %{message: "Unknown username or password."}
  end

  def render("register.json", %{user: _user}) do
    %{message: "Registration success"}
  end

  def render("registration.error.json", %{changeset: changeset}) do
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
end
