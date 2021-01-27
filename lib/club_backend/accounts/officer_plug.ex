defmodule ClubBackend.Accounts.OfficerPlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    with true <- Guardian.Plug.authenticated?(conn),
         user <- Guardian.Plug.current_resource(conn),
         true <- user.is_admin do
      conn
    else
      _ ->
        conn
        |> put_status(403)
        |> send_resp()
    end
  end
end
