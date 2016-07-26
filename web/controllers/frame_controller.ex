defmodule Kompax.FrameController do
  use Kompax.Web, :controller

  alias Kompax.Activity
  alias Kompax.Aspect
  alias Kompax.Tag

  def show(conn, _params) do
    activities = Repo.all(from a in Activity, where: a.published) |> Repo.preload([:sections, :annotations])
    aspects = Repo.all(Aspect)
              |> Repo.preload(tags: (from t in Tag, order_by: [asc: t.name]))
    render(conn, "show.json", frame: %{activities: activities, aspects: aspects})
  end
end
