defmodule AcmUcDemoWeb.FlightLive.Index do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Flights

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Flights
        <:actions>
          <.button variant="primary" navigate={~p"/flights/new"}>
            <.icon name="hero-plus" /> New Flight
          </.button>
        </:actions>
      </.header>

      <.table
        id="flights"
        rows={@streams.flights}
        row_click={fn {_id, flight} -> JS.navigate(~p"/flights/#{flight}") end}
      >
        <:col :let={{_id, flight}} label="Hobbs reading">{flight.hobbs_reading}</:col>
        <:col :let={{_id, flight}} label="Notes">{flight.notes}</:col>
        <:action :let={{_id, flight}}>
          <div class="sr-only">
            <.link navigate={~p"/flights/#{flight}"}>Show</.link>
          </div>
          <.link navigate={~p"/flights/#{flight}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, flight}}>
          <.link
            phx-click={JS.push("delete", value: %{id: flight.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Flights")
     |> stream(:flights, list_flights())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    flight = Flights.get_flight!(id)
    {:ok, _} = Flights.delete_flight(flight)

    {:noreply, stream_delete(socket, :flights, flight)}
  end

  defp list_flights() do
    Flights.list_flights()
  end
end
