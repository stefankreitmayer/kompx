defmodule Kompax.Repo.Migrations.CreateParagraph do
  use Ecto.Migration

  def change do
    create table(:paragraphs) do
      add :body, :text
      add :position, :integer
      add :bullet, :boolean, default: false
      add :section_id, references(:sections, on_delete: :delete_all)

      timestamps
    end

  end
end
