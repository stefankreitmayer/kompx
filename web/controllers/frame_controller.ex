defmodule Kompax.FrameController do
  use Kompax.Web, :controller

  alias Kompax.Activity
  alias Kompax.Section
  alias Kompax.Aspect
  alias Kompax.Tag

  def show(conn, _params) do
    activities = Repo.all(from a in Activity, where: a.published, order_by: a.title)
              |> Repo.preload(sections: (from s in Section, order_by: [asc: s.position]))
              |> Repo.preload(:annotations)
    aspects = Repo.all(Aspect)
              |> Repo.preload(tags: (from t in Tag, order_by: [asc: t.position]))
    render(conn, "show.json", frame: %{activities: activities, aspects: aspects})
  end
end
