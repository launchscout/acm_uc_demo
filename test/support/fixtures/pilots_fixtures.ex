defmodule AcmUcDemo.PilotsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AcmUcDemo.Pilots` context.
  """

  @doc """
  Generate a pilot.
  """
  def pilot_fixture(attrs \\ %{}) do
    {:ok, pilot} =
      attrs
      |> Enum.into(%{
        certificate_number: "some certificate_number",
        name: "some name"
      })
      |> AcmUcDemo.Pilots.create_pilot()

    pilot
  end
end
