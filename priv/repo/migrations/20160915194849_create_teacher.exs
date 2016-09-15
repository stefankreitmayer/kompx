defmodule Kompax.Repo.Migrations.CreateTeacher do
  use Ecto.Migration

  def change do
    create table(:teachers) do
      add :email, :string, null: false
      add :password_hash, :string
      add :password, :string, virtual: true

      timestamps()
    end

    create unique_index(:teachers, [:email])
  end
end
