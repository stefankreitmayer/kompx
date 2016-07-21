defmodule Kompax.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :aspect_id, references(:aspects, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:tags, [:name])
    create index(:tags, [:aspect_id])

  end
end
