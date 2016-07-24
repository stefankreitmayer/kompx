defmodule Kompax.FrameController do
  use Kompax.Web, :controller

  alias Kompax.Activity
  alias Kompax.Aspect

  def show(conn, _params) do
    activities = Repo.all(Activity) |> Repo.preload([:sections, :annotations])
    aspects = Repo.all(Aspect) |> Repo.preload([:tags])
    render(conn, "show.json", frame: %{activities: activities, aspects: aspects})
  end
end
