defmodule AcmUcDemo.FlightsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AcmUcDemo.Flights` context.
  """

  @doc """
  Generate a flight.
  """
  def flight_fixture(attrs \\ %{}) do
    {:ok, flight} =
      attrs
      |> Enum.into(%{
        hobbs_reading: "120.5",
        notes: "some notes"
      })
      |> AcmUcDemo.Flights.create_flight()

    flight
  end
end
