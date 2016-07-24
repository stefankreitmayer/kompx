defmodule Kompax.FrameView do
  use Kompax.Web, :view

  alias Kompax.ActivityView
  alias Kompax.AspectView

  def render("show.json", %{frame: frame}) do
    IO.inspect %{frame: render_one(frame, Kompax.FrameView, "frame.json")}
    %{frame: render_one(frame, Kompax.FrameView, "frame.json")}
  end

  def render("frame.json", %{frame: frame}) do
    %{}
    |> Map.put(:activities, ActivityView.render("index.json", activities: frame.activities))
    |> Map.put(:aspects, AspectView.render("index.json", aspects: frame.aspects))
  end
end
