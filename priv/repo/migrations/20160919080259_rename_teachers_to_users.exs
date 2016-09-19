defmodule Kompax.Repo.Migrations.RenameTeachersToUsers do
  use Ecto.Migration

  def up do
    drop table(:teachers)

    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string
      add :password, :string, virtual: true

      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop table(:users)

    create table(:teachers) do
      add :email, :string, null: false
      add :password_hash, :string
      add :password, :string, virtual: true

      timestamps()
    end

    create unique_index(:teachers, [:email])
  end
end
