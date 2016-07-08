defmodule Kompax.PageController do
  use Kompax.Web, :controller

  plug :put_layout, "elm.html"

  def index(conn, _params) do
    render conn, "index.html"
  end
end
