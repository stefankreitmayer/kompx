defmodule Kompax.FrameView do
  use Kompax.Web, :view

  def render("fetch.json", %{frame: frame}) do
    # %{data: render_one(frame, Kompax.FrameView, "frame.json")}
    %{dummy: frame}
  end
end
