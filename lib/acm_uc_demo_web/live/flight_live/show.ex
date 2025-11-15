defmodule AcmUcDemoWeb.FlightLive.Show do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Flights

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Flight {@flight.id}
        <:subtitle>This is a flight record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/flights"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/flights/#{@flight}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit flight
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Hobbs reading">{@flight.hobbs_reading}</:item>
        <:item title="Notes">{@flight.notes}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Flight")
     |> assign(:flight, Flights.get_flight!(id))}
  end
end
