defmodule AcmUcDemoWeb.FlightLiveTest do
  use AcmUcDemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import AcmUcDemo.FlightsFixtures

  @create_attrs %{hobbs_reading: "120.5", notes: "some notes"}
  @update_attrs %{hobbs_reading: "456.7", notes: "some updated notes"}
  @invalid_attrs %{hobbs_reading: nil, notes: nil}
  defp create_flight(_) do
    flight = flight_fixture()

    %{flight: flight}
  end

  describe "Index" do
    setup [:create_flight]

    test "lists all flights", %{conn: conn, flight: flight} do
      {:ok, _index_live, html} = live(conn, ~p"/flights")

      assert html =~ "Listing Flights"
      assert html =~ flight.notes
    end

    test "saves new flight", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/flights")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Flight")
               |> render_click()
               |> follow_redirect(conn, ~p"/flights/new")

      assert render(form_live) =~ "New Flight"

      assert form_live
             |> form("#flight-form", flight: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#flight-form", flight: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/flights")

      html = render(index_live)
      assert html =~ "Flight created successfully"
      assert html =~ "some notes"
    end

    test "updates flight in listing", %{conn: conn, flight: flight} do
      {:ok, index_live, _html} = live(conn, ~p"/flights")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#flights-#{flight.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/flights/#{flight}/edit")

      assert render(form_live) =~ "Edit Flight"

      assert form_live
             |> form("#flight-form", flight: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#flight-form", flight: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/flights")

      html = render(index_live)
      assert html =~ "Flight updated successfully"
      assert html =~ "some updated notes"
    end

    test "deletes flight in listing", %{conn: conn, flight: flight} do
      {:ok, index_live, _html} = live(conn, ~p"/flights")

      assert index_live |> element("#flights-#{flight.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#flights-#{flight.id}")
    end
  end

  describe "Show" do
    setup [:create_flight]

    test "displays flight", %{conn: conn, flight: flight} do
      {:ok, _show_live, html} = live(conn, ~p"/flights/#{flight}")

      assert html =~ "Show Flight"
      assert html =~ flight.notes
    end

    test "updates flight and returns to show", %{conn: conn, flight: flight} do
      {:ok, show_live, _html} = live(conn, ~p"/flights/#{flight}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/flights/#{flight}/edit?return_to=show")

      assert render(form_live) =~ "Edit Flight"

      assert form_live
             |> form("#flight-form", flight: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#flight-form", flight: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/flights/#{flight}")

      html = render(show_live)
      assert html =~ "Flight updated successfully"
      assert html =~ "some updated notes"
    end
  end
end
