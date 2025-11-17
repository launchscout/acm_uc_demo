defmodule AcmUcDemoWeb.AirplaneLiveTest do
  use AcmUcDemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import AcmUcDemo.AirplanesFixtures

  @create_attrs %{
    make: "some make",
    model: "some model",
    tail_number: "some tail_number",
    initial_hours: "120.5"
  }
  @update_attrs %{
    make: "some updated make",
    model: "some updated model",
    tail_number: "some updated tail_number",
    initial_hours: "456.7"
  }
  @invalid_attrs %{make: nil, model: nil, tail_number: nil, initial_hours: nil}
  defp create_airplane(_) do
    airplane = airplane_fixture()

    %{airplane: airplane}
  end

  describe "Index" do
    setup [:create_airplane]

    test "lists all airplanes", %{conn: conn, airplane: airplane} do
      {:ok, _index_live, html} = live(conn, ~p"/airplanes")

      assert html =~ "Listing Airplanes"
      assert html =~ airplane.make
    end

    test "saves new airplane", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/airplanes")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Airplane")
               |> render_click()
               |> follow_redirect(conn, ~p"/airplanes/new")

      assert render(form_live) =~ "New Airplane"

      assert form_live
             |> form("#airplane-form", airplane: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#airplane-form", airplane: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/airplanes")

      html = render(index_live)
      assert html =~ "Airplane created successfully"
      assert html =~ "some make"
    end

    test "updates airplane in listing", %{conn: conn, airplane: airplane} do
      {:ok, index_live, _html} = live(conn, ~p"/airplanes")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#airplanes-#{airplane.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/airplanes/#{airplane}/edit")

      assert render(form_live) =~ "Edit Airplane"

      assert form_live
             |> form("#airplane-form", airplane: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#airplane-form", airplane: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/airplanes")

      html = render(index_live)
      assert html =~ "Airplane updated successfully"
      assert html =~ "some updated make"
    end

    test "deletes airplane in listing", %{conn: conn, airplane: airplane} do
      {:ok, index_live, _html} = live(conn, ~p"/airplanes")

      assert index_live |> element("#airplanes-#{airplane.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#airplanes-#{airplane.id}")
    end
  end

  describe "Show" do
    setup [:create_airplane]

    test "displays airplane", %{conn: conn, airplane: airplane} do
      {:ok, _show_live, html} = live(conn, ~p"/airplanes/#{airplane}")

      assert html =~ "Show Airplane"
      assert html =~ airplane.make
    end

    test "updates airplane and returns to show", %{conn: conn, airplane: airplane} do
      {:ok, show_live, _html} = live(conn, ~p"/airplanes/#{airplane}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/airplanes/#{airplane}/edit?return_to=show")

      assert render(form_live) =~ "Edit Airplane"

      assert form_live
             |> form("#airplane-form", airplane: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#airplane-form", airplane: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/airplanes/#{airplane}")

      html = render(show_live)
      assert html =~ "Airplane updated successfully"
      assert html =~ "some updated make"
    end
  end
end
