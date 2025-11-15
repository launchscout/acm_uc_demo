defmodule AcmUcDemo.Flights.Flight do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flights" do
    field :hobbs_reading, :decimal
    field :notes, :string
    field :pilot_id, :id
    field :airplane_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(flight, attrs) do
    flight
    |> cast(attrs, [:hobbs_reading, :notes])
    |> validate_required([:hobbs_reading, :notes])
  end
end
