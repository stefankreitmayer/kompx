defmodule Kompax.Repo.Migrations.CreateActivity do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :title, :string
      add :summary, :string
      add :published, :boolean, default: false

      timestamps
    end

  end
end
