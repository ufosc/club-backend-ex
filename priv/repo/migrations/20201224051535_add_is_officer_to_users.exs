defmodule ClubBackend.Repo.Migrations.AddIsOfficerToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_officer, :boolean, default: false
    end
  end
end
