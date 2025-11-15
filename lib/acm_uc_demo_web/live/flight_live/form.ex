defmodule AcmUcDemoWeb.FlightLive.Form do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Flights
  alias AcmUcDemo.Flights.Flight

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage flight records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="flight-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:hobbs_reading]} type="number" label="Hobbs reading" step="any" />
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Flight</.button>
          <.button navigate={return_path(@return_to, @flight)}>Cancel</.button>
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
    flight = Flights.get_flight!(id)

    socket
    |> assign(:page_title, "Edit Flight")
    |> assign(:flight, flight)
    |> assign(:form, to_form(Flights.change_flight(flight)))
  end

  defp apply_action(socket, :new, _params) do
    flight = %Flight{}

    socket
    |> assign(:page_title, "New Flight")
    |> assign(:flight, flight)
    |> assign(:form, to_form(Flights.change_flight(flight)))
  end

  @impl true
  def handle_event("validate", %{"flight" => flight_params}, socket) do
    changeset = Flights.change_flight(socket.assigns.flight, flight_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"flight" => flight_params}, socket) do
    save_flight(socket, socket.assigns.live_action, flight_params)
  end

  defp save_flight(socket, :edit, flight_params) do
    case Flights.update_flight(socket.assigns.flight, flight_params) do
      {:ok, flight} ->
        {:noreply,
         socket
         |> put_flash(:info, "Flight updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, flight))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_flight(socket, :new, flight_params) do
    case Flights.create_flight(flight_params) do
      {:ok, flight} ->
        {:noreply,
         socket
         |> put_flash(:info, "Flight created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, flight))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _flight), do: ~p"/flights"
  defp return_path("show", flight), do: ~p"/flights/#{flight}"
end
