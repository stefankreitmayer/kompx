defmodule Kompax.Repo.Migrations.DropParagraphs do
  use Ecto.Migration

  def change do
    drop table(:paragraphs)
  end
end
