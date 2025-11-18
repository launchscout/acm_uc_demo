defmodule AcmUcDemo.Flights.Flight do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flights" do
    field :hobbs_reading, :decimal
    field :notes, :string
    belongs_to :pilot, AcmUcDemo.Pilots.Pilot
    belongs_to :airplane, AcmUcDemo.Airplanes.Airplane

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(flight, attrs) do
    flight
    |> cast(attrs, [:hobbs_reading, :notes])
    |> validate_required([:hobbs_reading, :notes])
  end
end
