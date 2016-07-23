defmodule Kompax.KnowledgebaseControllerTest do
  use Kompax.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows a dummy integer", %{conn: conn} do
    conn = get conn, knowledgebase_path(conn, :fetch)
    assert json_response(conn, 200) == %{"dummy" => 12345}
  end
end
