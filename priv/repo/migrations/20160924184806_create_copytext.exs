defmodule Kompax.Repo.Migrations.CreateCopytext do
  use Ecto.Migration

  def change do
    create table(:copytexts) do
      add :body, :text
      add :slug, :string

      timestamps()
    end
    create unique_index(:copytexts, [:slug])

  end
end
