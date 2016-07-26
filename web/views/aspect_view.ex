defmodule Kompax.AspectView do
  use Kompax.Web, :view

  def render("index.json", %{aspects: aspects}) do
    render_many(aspects, Kompax.AspectView, "aspect.json")
  end

  def render("aspect.json", %{aspect: aspect}) do
    %{name: aspect.name,
     position: aspect.position,
     options: Enum.map(aspect.tags, &tagToOption/1)}
  end

  defp tagToOption(tag) do
    %{tagId: tag.id, name: tag.name}
  end
end
