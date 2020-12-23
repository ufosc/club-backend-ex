defmodule ClubBackend.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :description, :string, null: false
      add :location, :string
      add :category, :string
      add :start_dt, :utc_datetime
      add :end_dt, :utc_datetime

      timestamps()
    end
  end
end
