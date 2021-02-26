defmodule ClubBackend.Accounts.OfficerPlug do
  import Plug.Conn

  @forbidden_error Jason.encode!(%{"error" => "forbidden"})

  def init(default), do: default

  def call(conn, _default) do
    with true <- Guardian.Plug.authenticated?(conn),
         user <- Guardian.Plug.current_resource(conn),
         true <- user.is_officer do
      conn
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, @forbidden_error)
        |> halt
    end
  end
end
