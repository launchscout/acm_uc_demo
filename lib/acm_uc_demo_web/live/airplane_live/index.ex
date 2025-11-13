defmodule AcmUcDemoWeb.AirplaneLive.Index do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Airplanes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Airplanes
        <:actions>
          <.button variant="primary" navigate={~p"/airplanes/new"}>
            <.icon name="hero-plus" /> New Airplane
          </.button>
        </:actions>
      </.header>

      <.table
        id="airplanes"
        rows={@streams.airplanes}
        row_click={fn {_id, airplane} -> JS.navigate(~p"/airplanes/#{airplane}") end}
      >
        <:col :let={{_id, airplane}} label="Make">{airplane.make}</:col>
        <:col :let={{_id, airplane}} label="Model">{airplane.model}</:col>
        <:col :let={{_id, airplane}} label="Tail number">{airplane.tail_number}</:col>
        <:col :let={{_id, airplane}} label="Initial hours">{airplane.initial_hours}</:col>
        <:action :let={{_id, airplane}}>
          <div class="sr-only">
            <.link navigate={~p"/airplanes/#{airplane}"}>Show</.link>
          </div>
          <.link navigate={~p"/airplanes/#{airplane}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, airplane}}>
          <.link
            phx-click={JS.push("delete", value: %{id: airplane.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Airplanes")
     |> stream(:airplanes, list_airplanes())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    airplane = Airplanes.get_airplane!(id)
    {:ok, _} = Airplanes.delete_airplane(airplane)

    {:noreply, stream_delete(socket, :airplanes, airplane)}
  end

  defp list_airplanes() do
    Airplanes.list_airplanes()
  end
end
