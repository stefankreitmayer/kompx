defmodule Kompax.PageController do
  use Kompax.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
