defmodule Kompax.UserAuthentication do
  def authenticate_user(conn, _opts) do
    if Kompax.UserSession.current_user(conn) do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: Kompax.Router.Helpers.session_path(conn, :new))
      |> Plug.Conn.halt
    end
  end
end
