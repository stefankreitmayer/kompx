defmodule Kompax.ActivityView do
  use Kompax.Web, :view

  alias Kompax.Moekdown
  alias Kompax.SectionView

  def toggleButtonClass(activity, tag) do
    if Enum.find(activity.annotations, fn(a) -> a.tag_id==tag.id end) do
      "btn btn-lg btn-primary"
    else
      "btn btn-lg btn-default"
    end
  end

  def toggleButtonIcon(activity, tag) do
    if Enum.find(activity.annotations, fn(a) -> a.tag_id==tag.id end) do
      "glyphicon glyphicon-ok"
    else
      "glyphicon glyphicon-minus invisible"
    end
  end

  def render("index.json", %{activities: activities}) do
    render_many(activities, Kompax.ActivityView, "activity.json")
  end

  def render("activity.json", %{activity: activity}) do
    %{id: activity.id,
     title: activity.title,
     summary: activity.summary,
     author: activity.author,
     sections: SectionView.render("index.json", sections: activity.sections),
     tagIds: Enum.map(activity.annotations, fn(annotation) -> annotation.tag_id end)}
  end
end
