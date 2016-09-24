defmodule Kompax.PageControllerTest do
  use Kompax.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Die freie Onlinebibliothek"
  end
end
