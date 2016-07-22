defmodule Kompax.AnnotationController do
  use Kompax.Web, :controller

  alias Ecto.Changeset

  alias Kompax.Annotation
  alias Kompax.Tag
  alias Kompax.Activity

  def toggle(conn, %{"activity_id" => activity_id, "tag_id" => tag_id}) do
    activity = Repo.get(Activity, activity_id)
    tag = Repo.get(Tag, tag_id)
    annotation = Repo.get_by(Annotation, activity_id: activity.id, tag_id: tag.id)
    if annotation do
      Repo.delete!(annotation)
    else
      changeset = Changeset.change(%Annotation{}, activity_id: activity.id, tag_id: tag.id)
                  |> Repo.insert!
    end
    redirect(conn, to: activity_path(conn, :show, activity_id))
  end
end
