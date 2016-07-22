defmodule Kompax.AnnotationController do
  use Kompax.Web, :controller

  alias Ecto.Changeset

  alias Kompax.Annotation
  alias Kompax.Tag
  alias Kompax.Activity
  alias Kompax.Util

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
    url = activity_path(conn, :show, activity_id)<>"#"<>Util.aspect_anchor(tag)
    redirect(conn, to: url)
  end
end
