defmodule AcmUcDemo.Pilots.Pilot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pilots" do
    field :name, :string
    field :certificate_number, :string

    has_many :flights, AcmUcDemo.Flights.Flight

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pilot, attrs) do
    pilot
    |> cast(attrs, [:name, :certificate_number])
    |> validate_required([:name, :certificate_number])
  end
end
