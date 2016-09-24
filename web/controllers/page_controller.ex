defmodule Kompax.PageController do
  use Kompax.Web, :controller

  alias Kompax.Copytext
  alias Kompax.KindaMarkdown

  import Plug.Conn, only: [assign: 3]

  def home(conn, _params) do
    conn
    |> assign(:page_title, "KoLibris")
    |> render("home.html")
  end

  def about(conn, _params) do
    conn
    |> plain_page(%{copytext_slug: "about", page_title: "Über das Projekt"})
  end

  def contribute(conn, _params) do
    conn
    |> plain_page(%{copytext_slug: "aufgaben-erstellen", page_title: "Aufgaben erstellen"})
  end

  def imprint(conn, _params) do
    conn
    |> plain_page(%{copytext_slug: "impressum", page_title: "Impressum"})
  end

  def finder(conn, _params) do
    conn
    |> put_layout("elm.html")
    |> render("finder.html")
  end

  defp plain_page(conn, %{copytext_slug: copytext_slug, page_title: page_title}) do
    copy_html = Repo.get_by!(Copytext, %{slug: copytext_slug}).body
            |> KindaMarkdown.to_html
    conn
    |> assign(:page_title, "KoLibris - "<>page_title)
    |> assign(:include_homelink, true)
    |> render("copytext.html", copy_html: copy_html)
  end
end
