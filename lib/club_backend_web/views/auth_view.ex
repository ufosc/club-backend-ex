defmodule ClubBackendWeb.AuthView do
  use ClubBackendWeb, :view

  def render("login.json", %{user: user} = _params) do
    %{username: user.username}
  end

  def render("error.json", _) do
    %{message: "Unknown username or password."}
  end
end
