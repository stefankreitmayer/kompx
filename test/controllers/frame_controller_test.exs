defmodule Kompax.FrameControllerTest do
  use Kompax.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows the frame, comprising activities and aspects", %{conn: conn} do
    conn = get conn, frame_path(conn, :show)
    assert json_response(conn, 200) == %{"frame" => %{"activities" => [], "aspects" => []}}
  end
end
