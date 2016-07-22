defmodule Kompax.ActivityView do
  use Kompax.Web, :view

  alias Kompax.Moekdown

  def classForToggle(activity, tag) do
    if Enum.find(activity.annotations, fn(a) -> a.tag_id==tag.id end) do
      "btn btn-lg btn-success"
    else
      "btn btn-lg btn-danger"
    end
  end
end
