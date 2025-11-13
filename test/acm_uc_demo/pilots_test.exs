defmodule AcmUcDemo.PilotsTest do
  use AcmUcDemo.DataCase

  alias AcmUcDemo.Pilots

  describe "pilots" do
    alias AcmUcDemo.Pilots.Pilot

    import AcmUcDemo.PilotsFixtures

    @invalid_attrs %{name: nil, certificate_number: nil}

    test "list_pilots/0 returns all pilots" do
      pilot = pilot_fixture()
      assert Pilots.list_pilots() == [pilot]
    end

    test "get_pilot!/1 returns the pilot with given id" do
      pilot = pilot_fixture()
      assert Pilots.get_pilot!(pilot.id) == pilot
    end

    test "create_pilot/1 with valid data creates a pilot" do
      valid_attrs = %{name: "some name", certificate_number: "some certificate_number"}

      assert {:ok, %Pilot{} = pilot} = Pilots.create_pilot(valid_attrs)
      assert pilot.name == "some name"
      assert pilot.certificate_number == "some certificate_number"
    end

    test "create_pilot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pilots.create_pilot(@invalid_attrs)
    end

    test "update_pilot/2 with valid data updates the pilot" do
      pilot = pilot_fixture()
      update_attrs = %{name: "some updated name", certificate_number: "some updated certificate_number"}

      assert {:ok, %Pilot{} = pilot} = Pilots.update_pilot(pilot, update_attrs)
      assert pilot.name == "some updated name"
      assert pilot.certificate_number == "some updated certificate_number"
    end

    test "update_pilot/2 with invalid data returns error changeset" do
      pilot = pilot_fixture()
      assert {:error, %Ecto.Changeset{}} = Pilots.update_pilot(pilot, @invalid_attrs)
      assert pilot == Pilots.get_pilot!(pilot.id)
    end

    test "delete_pilot/1 deletes the pilot" do
      pilot = pilot_fixture()
      assert {:ok, %Pilot{}} = Pilots.delete_pilot(pilot)
      assert_raise Ecto.NoResultsError, fn -> Pilots.get_pilot!(pilot.id) end
    end

    test "change_pilot/1 returns a pilot changeset" do
      pilot = pilot_fixture()
      assert %Ecto.Changeset{} = Pilots.change_pilot(pilot)
    end
  end
end
