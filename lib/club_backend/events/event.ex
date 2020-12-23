defmodule ClubBackend.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :category, :string
    field :description, :string
    field :end_dt, :utc_datetime
    field :location, :string
    field :start_dt, :utc_datetime
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :location, :category, :start_dt, :end_dt])
    |> validate_required([:title, :description, :category, :start_dt, :end_dt])
  end
end
