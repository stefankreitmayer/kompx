defmodule Kompax.KnowledgebaseView do
  use Kompax.Web, :view

  def render("fetch.json", %{knowledgebase: knowledgebase}) do
    # %{data: render_one(knowledgebase, Kompax.KnowledgebaseView, "knowledgebase.json")}
    %{dummy: knowledgebase}
  end
end
