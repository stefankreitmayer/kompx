defmodule Kompax.PageControllerTest do
  use Kompax.ConnCase

  alias Kompax.Copytext

  test "about", %{conn: conn} do
    %Copytext{slug: "about", body: "Abcdefg"} |> Repo.insert!
    conn = conn |> get(page_path(conn, :about))
    assert html_response(conn, 200) =~ "Über das Projekt"
    assert html_response(conn, 200) =~ "Abcdefg"
  end

  test "contribute", %{conn: conn} do
    %Copytext{slug: "aufgaben-erstellen", body: "Abcdefg"} |> Repo.insert!
    conn = conn |> get(page_path(conn, :contribute))
    assert html_response(conn, 200) =~ "Aufgaben erstellen"
    assert html_response(conn, 200) =~ "Abcdefg"
  end

  test "imprint", %{conn: conn} do
    %Copytext{slug: "impressum", body: "Abcdefg"} |> Repo.insert!
    conn = conn |> get(page_path(conn, :imprint))
    assert html_response(conn, 200) =~ "Impressum"
    assert html_response(conn, 200) =~ "Abcdefg"
  end
end
