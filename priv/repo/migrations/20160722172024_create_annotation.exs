defmodule Kompax.Repo.Migrations.CreateAnnotation do
  use Ecto.Migration

  def change do
    create table(:annotations) do
      add :activity_id, references(:activities, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end
    create index(:annotations, [:activity_id])
    create index(:annotations, [:tag_id])

  end
end
