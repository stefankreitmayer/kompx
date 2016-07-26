defmodule Kompax.ActivityView do
  use Kompax.Web, :view

  alias Kompax.Moekdown
  alias Kompax.SectionView

  def classForToggle(activity, tag) do
    if Enum.find(activity.annotations, fn(a) -> a.tag_id==tag.id end) do
      "btn btn-lg btn-success"
    else
      "btn btn-lg btn-danger"
    end
  end

  def render("index.json", %{activities: activities}) do
    render_many(activities, Kompax.ActivityView, "activity.json")
  end

  def render("activity.json", %{activity: activity}) do
    %{id: activity.id,
     title: activity.title,
     summary: activity.summary,
     sections: SectionView.render("index.json", sections: activity.sections),
     tagIds: Enum.map(activity.annotations, fn(annotation) -> annotation.tag_id end)}
  end
end
