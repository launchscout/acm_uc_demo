defmodule AcmUcDemoWeb.PilotLive.Show do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Pilots

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Pilot {@pilot.id}
        <:subtitle>This is a pilot record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/pilots"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/pilots/#{@pilot}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit pilot
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@pilot.name}</:item>
        <:item title="Certificate number">{@pilot.certificate_number}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Pilot")
     |> assign(:pilot, Pilots.get_pilot!(id))}
  end
end
