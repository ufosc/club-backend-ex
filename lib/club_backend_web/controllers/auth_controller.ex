defmodule ClubBackendWeb.AuthController do
  use ClubBackendWeb, :controller

  alias ClubBackend.Accounts

  def login(conn, %{"username" => username, "password" => password} = _params) do
    case Accounts.login(username, password) do
      {:ok, token} -> render(conn, "login.json", %{token: token})
      {:error, _} -> conn |> put_status(400) |> render("login.error.json", %{})
    end
  end

  def login(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{message: "Bad request"})
  end

  def register(conn, %{"username" => username, "password" => password} = _params) do
    case Accounts.register(username, password) do
      {:ok, token} ->
        render(conn, "register.json", %{token: token})

      {:error, changeset} ->
        conn |> put_status(400) |> render("registration.error.json", %{changeset: changeset})
    end
  end

  def register(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{message: "Bad request"})
  end
end
