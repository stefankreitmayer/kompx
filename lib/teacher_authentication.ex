defmodule Kompax.TeacherAuthentication do
  def authenticate_teacher(conn, _opts) do
    if Kompax.TeacherSession.current_teacher(conn) do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: Kompax.Router.Helpers.session_path(conn, :new))
      |> Plug.Conn.halt
    end
  end
end
