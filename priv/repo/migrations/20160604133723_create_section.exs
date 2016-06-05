defmodule Kompax.Repo.Migrations.CreateSection do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :title, :string
      add :position, :integer
      add :activity_id, references(:activities, on_delete: :delete_all)

      timestamps
    end

  end
end
