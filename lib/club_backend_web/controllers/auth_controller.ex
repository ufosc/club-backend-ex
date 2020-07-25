defmodule ClubBackendWeb.AuthController do
  use ClubBackendWeb, :controller

  alias ClubBackend.Accounts

  def login(conn, %{"username" => username, "password" => password} = _params) do
    case Accounts.login(username, password) do
      {:ok, user} -> render(conn, "login.json", %{user: user})
      {:error, _} -> conn |> put_status(400) |> render("error.json", %{})
    end
  end

  def login(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{message: "Bad request"})
  end
end
