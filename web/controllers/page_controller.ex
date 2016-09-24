defmodule Kompax.PageController do
  use Kompax.Web, :controller

  import Plug.Conn, only: [assign: 3]

  def home(conn, _params) do
    conn
    |> assign(:page_title, "KoLibris")
    |> render("home.html")
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, "KoLibris - Über das Projekt")
    |> assign(:include_homelink, true)
    |> render("about.html")
  end

  def contribute(conn, _params) do
    conn
    |> assign(:page_title, "KoLibris - Selbst Aufgaben erstellen")
    |> assign(:include_homelink, true)
    |> render("contribute.html")
  end

  def imprint(conn, _params) do
    conn
    |> assign(:page_title, "KoLibris - Impressum")
    |> assign(:include_homelink, true)
    |> render("imprint.html")
  end

  def finder(conn, _params) do
    conn
    |> put_layout("elm.html")
    |> render("finder.html")
  end
end
