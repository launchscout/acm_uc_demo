defmodule AcmUcDemoWeb.PilotLiveTest do
  use AcmUcDemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import AcmUcDemo.PilotsFixtures

  @create_attrs %{name: "some name", certificate_number: "some certificate_number"}
  @update_attrs %{
    name: "some updated name",
    certificate_number: "some updated certificate_number"
  }
  @invalid_attrs %{name: nil, certificate_number: nil}
  defp create_pilot(_) do
    pilot = pilot_fixture()

    %{pilot: pilot}
  end

  describe "Index" do
    setup [:create_pilot]

    test "lists all pilots", %{conn: conn, pilot: pilot} do
      {:ok, _index_live, html} = live(conn, ~p"/pilots")

      assert html =~ "Listing Pilots"
      assert html =~ pilot.name
    end

    test "saves new pilot", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pilots")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Pilot")
               |> render_click()
               |> follow_redirect(conn, ~p"/pilots/new")

      assert render(form_live) =~ "New Pilot"

      assert form_live
             |> form("#pilot-form", pilot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#pilot-form", pilot: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/pilots")

      html = render(index_live)
      assert html =~ "Pilot created successfully"
      assert html =~ "some name"
    end

    test "updates pilot in listing", %{conn: conn, pilot: pilot} do
      {:ok, index_live, _html} = live(conn, ~p"/pilots")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#pilots-#{pilot.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/pilots/#{pilot}/edit")

      assert render(form_live) =~ "Edit Pilot"

      assert form_live
             |> form("#pilot-form", pilot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#pilot-form", pilot: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/pilots")

      html = render(index_live)
      assert html =~ "Pilot updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes pilot in listing", %{conn: conn, pilot: pilot} do
      {:ok, index_live, _html} = live(conn, ~p"/pilots")

      assert index_live |> element("#pilots-#{pilot.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pilots-#{pilot.id}")
    end
  end

  describe "Show" do
    setup [:create_pilot]

    test "displays pilot", %{conn: conn, pilot: pilot} do
      {:ok, _show_live, html} = live(conn, ~p"/pilots/#{pilot}")

      assert html =~ "Show Pilot"
      assert html =~ pilot.name
    end

    test "updates pilot and returns to show", %{conn: conn, pilot: pilot} do
      {:ok, show_live, _html} = live(conn, ~p"/pilots/#{pilot}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/pilots/#{pilot}/edit?return_to=show")

      assert render(form_live) =~ "Edit Pilot"

      assert form_live
             |> form("#pilot-form", pilot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#pilot-form", pilot: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/pilots/#{pilot}")

      html = render(show_live)
      assert html =~ "Pilot updated successfully"
      assert html =~ "some updated name"
    end
  end
end
