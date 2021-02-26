defmodule ClubBackendWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ClubBackendWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ClubBackendWeb.ConnCase
      import ClubBackend.Factory
      import ClubBackend.Guardian

      def get_auth_token(user) do
        {:ok, token, _claims} = encode_and_sign(user, %{}, auth_time: true)
        token
      end

      def add_token_to_conn(token, conn) do
        conn
          |> put_req_header("authorization", "Bearer " <> token)
      end

      alias ClubBackendWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ClubBackendWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ClubBackend.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ClubBackend.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
