defmodule AcmUcDemo.Repo.Migrations.CreatePilots do
  use Ecto.Migration

  def change do
    create table(:pilots) do
      add :name, :string
      add :certificate_number, :string

      timestamps(type: :utc_datetime)
    end
  end
end
