defmodule AcmUcDemo.AirplanesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AcmUcDemo.Airplanes` context.
  """

  @doc """
  Generate a airplane.
  """
  def airplane_fixture(attrs \\ %{}) do
    {:ok, airplane} =
      attrs
      |> Enum.into(%{
        initial_hours: "120.5",
        make: "some make",
        model: "some model",
        tail_number: "some tail_number"
      })
      |> AcmUcDemo.Airplanes.create_airplane()

    airplane
  end
end
