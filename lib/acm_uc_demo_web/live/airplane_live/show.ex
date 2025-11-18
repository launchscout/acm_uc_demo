defmodule AcmUcDemoWeb.AirplaneLive.Show do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Airplanes
  alias AcmUcDemo.Flights

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Airplane {@airplane.id}
        <:subtitle>This is a airplane record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/airplanes"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/airplanes/#{@airplane}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit airplane
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Make">{@airplane.make}</:item>
        <:item title="Model">{@airplane.model}</:item>
        <:item title="Tail number">{@airplane.tail_number}</:item>
        <:item title="Initial hours">{@airplane.initial_hours}</:item>
      </.list>

      <div class="mt-11">
        <.header>
          Flights
          <:subtitle>Flight history for this airplane</:subtitle>
        </.header>

        <div class="mt-6">
          <%= if @flights == [] do %>
            <div class="text-center py-12 text-gray-500">
              No flights recorded for this airplane yet.
            </div>
          <% else %>
            <.table id="flights-table" rows={@flights}>
              <:col :let={flight} label="Pilot">{flight.pilot.name}</:col>
              <:col :let={flight} label="Hobbs Reading">{flight.hobbs_reading}</:col>
              <:col :let={flight} label="Notes">{flight.notes}</:col>
              <:col :let={flight} label="Date">
                {Calendar.strftime(flight.inserted_at, "%Y-%m-%d %I:%M %p")}
              </:col>
            </.table>
          <% end %>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    airplane = Airplanes.get_airplane!(id)
    flights = Flights.list_flights_by_airplane(id)

    {:ok,
     socket
     |> assign(:page_title, "Show Airplane")
     |> assign(:airplane, airplane)
     |> assign(:flights, flights)}
  end
end
