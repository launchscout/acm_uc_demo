defmodule AcmUcDemoWeb.PilotLive.Index do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Pilots

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Pilots
        <:actions>
          <.button variant="primary" navigate={~p"/pilots/new"}>
            <.icon name="hero-plus" /> New Pilot
          </.button>
        </:actions>
      </.header>

      <.table
        id="pilots"
        rows={@streams.pilots}
        row_click={fn {_id, pilot} -> JS.navigate(~p"/pilots/#{pilot}") end}
      >
        <:col :let={{_id, pilot}} label="Name">{pilot.name}</:col>
        <:col :let={{_id, pilot}} label="Certificate number">{pilot.certificate_number}</:col>
        <:action :let={{_id, pilot}}>
          <div class="sr-only">
            <.link navigate={~p"/pilots/#{pilot}"}>Show</.link>
          </div>
          <.link navigate={~p"/pilots/#{pilot}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, pilot}}>
          <.link
            phx-click={JS.push("delete", value: %{id: pilot.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Pilots")
     |> stream(:pilots, list_pilots())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pilot = Pilots.get_pilot!(id)
    {:ok, _} = Pilots.delete_pilot(pilot)

    {:noreply, stream_delete(socket, :pilots, pilot)}
  end

  defp list_pilots() do
    Pilots.list_pilots()
  end
end
