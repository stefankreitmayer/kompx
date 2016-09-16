defmodule Kompax.TeacherSession do
  def login(conn, teacher) do
    conn
    |> Plug.Conn.put_session(:teacher_id, teacher.id)
    |> Plug.Conn.assign(:current_teacher, teacher)
  end

  def logout(conn) do
    conn
    |> Plug.Conn.delete_session(:teacher_id)
    |> Plug.Conn.assign(:current_teacher, nil)
  end

  def current_teacher(conn) do
    conn.assigns[:current_teacher] || load_current_teacher(conn)
  end

  defp load_current_teacher(conn) do
    id = Plug.Conn.get_session(conn, :teacher_id)
    if id do
      teacher = Kompax.Repo.get!(Kompax.Teacher, id)
      login(conn, teacher)
    end
  end
end
