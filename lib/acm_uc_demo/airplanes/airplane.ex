defmodule AcmUcDemo.Airplanes.Airplane do
  use Ecto.Schema
  import Ecto.Changeset

  schema "airplanes" do
    field :make, :string
    field :model, :string
    field :tail_number, :string
    field :initial_hours, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(airplane, attrs) do
    airplane
    |> cast(attrs, [:make, :model, :tail_number, :initial_hours])
    |> validate_required([:make, :model, :tail_number, :initial_hours])
  end
end
