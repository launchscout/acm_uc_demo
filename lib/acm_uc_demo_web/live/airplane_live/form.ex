defmodule AcmUcDemoWeb.AirplaneLive.Form do
  use AcmUcDemoWeb, :live_view

  alias AcmUcDemo.Airplanes
  alias AcmUcDemo.Airplanes.Airplane

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage airplane records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="airplane-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:make]} type="text" label="Make" />
        <.input field={@form[:model]} type="text" label="Model" />
        <.input field={@form[:tail_number]} type="text" label="Tail number" />
        <.input field={@form[:initial_hours]} type="number" label="Initial hours" step="any" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Airplane</.button>
          <.button navigate={return_path(@return_to, @airplane)}>Cancel</.button>
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
    airplane = Airplanes.get_airplane!(id)

    socket
    |> assign(:page_title, "Edit Airplane")
    |> assign(:airplane, airplane)
    |> assign(:form, to_form(Airplanes.change_airplane(airplane)))
  end

  defp apply_action(socket, :new, _params) do
    airplane = %Airplane{}

    socket
    |> assign(:page_title, "New Airplane")
    |> assign(:airplane, airplane)
    |> assign(:form, to_form(Airplanes.change_airplane(airplane)))
  end

  @impl true
  def handle_event("validate", %{"airplane" => airplane_params}, socket) do
    changeset = Airplanes.change_airplane(socket.assigns.airplane, airplane_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"airplane" => airplane_params}, socket) do
    save_airplane(socket, socket.assigns.live_action, airplane_params)
  end

  defp save_airplane(socket, :edit, airplane_params) do
    case Airplanes.update_airplane(socket.assigns.airplane, airplane_params) do
      {:ok, airplane} ->
        {:noreply,
         socket
         |> put_flash(:info, "Airplane updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, airplane))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_airplane(socket, :new, airplane_params) do
    case Airplanes.create_airplane(airplane_params) do
      {:ok, airplane} ->
        {:noreply,
         socket
         |> put_flash(:info, "Airplane created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, airplane))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _airplane), do: ~p"/airplanes"
  defp return_path("show", airplane), do: ~p"/airplanes/#{airplane}"
end
