defmodule AcmUcDemo.FlightsTest do
  use AcmUcDemo.DataCase

  alias AcmUcDemo.Flights
  alias AcmUcDemo.Repo

  describe "flights" do
    alias AcmUcDemo.Flights.Flight

    import AcmUcDemo.FlightsFixtures
    import AcmUcDemo.PilotsFixtures
    import AcmUcDemo.AirplanesFixtures

    @invalid_attrs %{hobbs_reading: nil, notes: nil, pilot_id: nil, airplane_id: nil}

    test "list_flights/0 returns all flights" do
      flight = flight_fixture()
      assert Flights.list_flights() == [flight]
    end

    test "get_flight!/1 returns the flight with given id" do
      flight = flight_fixture()
      assert Flights.get_flight!(flight.id) == flight
    end

    test "create_flight/1 with valid data creates a flight" do
      pilot = pilot_fixture()
      airplane = airplane_fixture()
      valid_attrs = %{hobbs_reading: "120.5", notes: "some notes", pilot_id: pilot.id, airplane_id: airplane.id}

      assert {:ok, %Flight{} = flight} = Flights.create_flight(valid_attrs)
      assert flight.hobbs_reading == Decimal.new("120.5")
      assert flight.notes == "some notes"
      assert flight.pilot_id == pilot.id
      assert flight.airplane_id == airplane.id
    end

    test "create_flight/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Flights.create_flight(@invalid_attrs)
    end

    test "update_flight/2 with valid data updates the flight" do
      flight = flight_fixture()
      update_attrs = %{hobbs_reading: "456.7", notes: "some updated notes"}

      assert {:ok, %Flight{} = flight} = Flights.update_flight(flight, update_attrs)
      assert flight.hobbs_reading == Decimal.new("456.7")
      assert flight.notes == "some updated notes"
    end

    test "update_flight/2 with invalid data returns error changeset" do
      flight = flight_fixture()
      assert {:error, %Ecto.Changeset{}} = Flights.update_flight(flight, @invalid_attrs)
      assert flight == Flights.get_flight!(flight.id)
    end

    test "delete_flight/1 deletes the flight" do
      flight = flight_fixture()
      assert {:ok, %Flight{}} = Flights.delete_flight(flight)
      assert_raise Ecto.NoResultsError, fn -> Flights.get_flight!(flight.id) end
    end

    test "change_flight/1 returns a flight changeset" do
      flight = flight_fixture()
      assert %Ecto.Changeset{} = Flights.change_flight(flight)
    end

    test "flight belongs to a pilot" do
      flight = flight_fixture()
      loaded_flight = Repo.preload(flight, :pilot)
      assert loaded_flight.pilot.id == flight.pilot_id
      assert loaded_flight.pilot.name != nil
    end

    test "flight belongs to an airplane" do
      flight = flight_fixture()
      loaded_flight = Repo.preload(flight, :airplane)
      assert loaded_flight.airplane.id == flight.airplane_id
      assert loaded_flight.airplane.tail_number != nil
    end

    test "create_flight/1 requires pilot_id" do
      airplane = airplane_fixture()
      invalid_attrs = %{hobbs_reading: "120.5", notes: "some notes", airplane_id: airplane.id}
      assert {:error, %Ecto.Changeset{}} = Flights.create_flight(invalid_attrs)
    end

    test "create_flight/1 requires airplane_id" do
      pilot = pilot_fixture()
      invalid_attrs = %{hobbs_reading: "120.5", notes: "some notes", pilot_id: pilot.id}
      assert {:error, %Ecto.Changeset{}} = Flights.create_flight(invalid_attrs)
    end
  end
end
