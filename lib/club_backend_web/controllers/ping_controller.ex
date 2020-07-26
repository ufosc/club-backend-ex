defmodule ClubBackendWeb.PingController do
  use ClubBackendWeb, :controller

  def ping(conn, _) do
    conn
    |> text("pong")
  end
end
