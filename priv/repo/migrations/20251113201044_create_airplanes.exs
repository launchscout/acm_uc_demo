defmodule AcmUcDemo.Repo.Migrations.CreateAirplanes do
  use Ecto.Migration

  def change do
    create table(:airplanes) do
      add :make, :string
      add :model, :string
      add :tail_number, :string
      add :initial_hours, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
