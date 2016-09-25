defmodule Kompax.Repo.Migrations.AddAuthorToActivity do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :author, :string
    end
  end
end
