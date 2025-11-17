defmodule AcmUcDemo.FlightsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AcmUcDemo.Flights` context.
  """

  import AcmUcDemo.PilotsFixtures
  import AcmUcDemo.AirplanesFixtures

  @doc """
  Generate a flight.
  """
  def flight_fixture(attrs \\ %{}) do
    pilot = pilot_fixture()
    airplane = airplane_fixture()

    {:ok, flight} =
      attrs
      |> Enum.into(%{
        hobbs_reading: "120.5",
        notes: "some notes",
        pilot_id: pilot.id,
        airplane_id: airplane.id
      })
      |> AcmUcDemo.Flights.create_flight()

    flight
  end
end
