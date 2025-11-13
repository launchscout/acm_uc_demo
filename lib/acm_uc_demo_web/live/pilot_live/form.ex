defmodule AcmUcDemoWeb.PilotLive.Form do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Pilots
  alias AcmUcDemo.Pilots.Pilot

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage pilot records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="pilot-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:certificate_number]} type="text" label="Certificate number" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Pilot</.button>
          <.button navigate={return_path(@return_to, @pilot)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    pilot = Pilots.get_pilot!(id)

    socket
    |> assign(:page_title, "Edit Pilot")
    |> assign(:pilot, pilot)
    |> assign(:form, to_form(Pilots.change_pilot(pilot)))
  end

  defp apply_action(socket, :new, _params) do
    pilot = %Pilot{}

    socket
    |> assign(:page_title, "New Pilot")
    |> assign(:pilot, pilot)
    |> assign(:form, to_form(Pilots.change_pilot(pilot)))
  end

  @impl true
  def handle_event("validate", %{"pilot" => pilot_params}, socket) do
    changeset = Pilots.change_pilot(socket.assigns.pilot, pilot_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"pilot" => pilot_params}, socket) do
    save_pilot(socket, socket.assigns.live_action, pilot_params)
  end

  defp save_pilot(socket, :edit, pilot_params) do
    case Pilots.update_pilot(socket.assigns.pilot, pilot_params) do
      {:ok, pilot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pilot updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, pilot))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_pilot(socket, :new, pilot_params) do
    case Pilots.create_pilot(pilot_params) do
      {:ok, pilot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pilot created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, pilot))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _pilot), do: ~p"/pilots"
  defp return_path("show", pilot), do: ~p"/pilots/#{pilot}"
end
