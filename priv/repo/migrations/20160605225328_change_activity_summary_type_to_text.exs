defmodule Kompax.Repo.Migrations.ChangeActivitySummaryTypeToText do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      modify(:summary, :text)
    end
  end
end
