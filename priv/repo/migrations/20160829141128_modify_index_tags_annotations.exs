defmodule Kompax.Repo.Migrations.ModifyIndexTagsAnnotations do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE annotations DROP CONSTRAINT annotations_tag_id_fkey"
    alter table(:annotations) do
      modify :tag_id, references(:tags, on_delete: :delete_all)
    end
  end
end
