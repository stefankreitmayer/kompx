defmodule Kompax.Repo.Migrations.AddBodyToSection do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :body, :text, default: ""
    end
  end
end
