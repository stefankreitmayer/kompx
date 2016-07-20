defmodule Kompax.Repo.Migrations.CreateAspect do
  use Ecto.Migration

  def change do
    create table(:aspects) do
      add :name, :string
      add :position, :integer

      timestamps()
    end

  end
end
