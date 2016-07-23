defmodule Kompax.KnowledgebaseController do
  use Kompax.Web, :controller

  def fetch(conn, _params) do
    render(conn, "fetch.json", knowledgebase: 12345)
  end
end
