defmodule Kompax.FrameController do
  use Kompax.Web, :controller

  def fetch(conn, _params) do
    render(conn, "fetch.json", frame: 12345)
  end
end
