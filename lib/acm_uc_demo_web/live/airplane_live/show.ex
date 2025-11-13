defmodule AcmUcDemoWeb.AirplaneLive.Show do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Airplanes

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
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Airplane")
     |> assign(:airplane, Airplanes.get_airplane!(id))}
  end
end
