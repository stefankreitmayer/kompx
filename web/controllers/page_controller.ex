defmodule Kompax.PageController do
  use Kompax.Web, :controller


  def home(conn, _params) do
    render conn, "home.html"
  end

  def finder(conn, _params) do
    conn
    |> put_layout("elm.html")
    |> render("finder.html")
  end
end
