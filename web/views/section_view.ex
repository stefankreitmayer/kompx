defmodule Kompax.SectionView do
  use Kompax.Web, :view

  alias Kompax.Moekdown

  def render("index.json", %{sections: sections}) do
    render_many(sections, Kompax.SectionView, "section.json")
  end

  def render("section.json", %{section: section}) do
    %{title: section.title,
     body: Moekdown.html(section.body)}
  end
end
