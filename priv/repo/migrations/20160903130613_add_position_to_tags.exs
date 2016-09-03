defmodule Kompax.Repo.Migrations.AddPositionToTags do
  use Ecto.Migration

  def change do
    alter table(:tags) do
      add :position, :integer, default: 0
    end
  end
end
