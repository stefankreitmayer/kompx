defmodule Kompax.SessionController do
  use Kompax.Web, :controller

  alias Kompax.TeacherSession
  alias Kompax.Teacher

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  plug :put_layout, "visitor.html"

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    teacher = Repo.get_by(Teacher, email: email)
    if teacher && checkpw(password, teacher.password_hash) do
      conn
      |> TeacherSession.login(teacher)
    else
      dummy_checkpw
      conn
    end
  end

  def delete(conn, _params) do
    conn
    |> TeacherSession.logout
    |> redirect(to: page_path(conn, :index))
  end
end
