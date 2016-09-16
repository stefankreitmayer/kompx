defmodule Kompax.SessionControllerTest do
  use Kompax.ConnCase

  alias Kompax.TeacherSession
  alias Kompax.Teacher

  import Kompax.ConnCase, only: [with_current_teacher: 2]

  @valid_attrs %{email: "bar@baz.com", password: "s3cr3t"}

  setup do
    conn = build_conn()
    {:ok, conn: conn, teacher: create_teacher}
  end

  defp create_teacher do
    Teacher.changeset(%Teacher{}, @valid_attrs)
    |> Repo.insert!
  end

  test "logs in", %{conn: conn, teacher: teacher} do
    conn = conn |> post(session_path(conn, :create), @valid_attrs)
    assert Plug.Conn.get_session(conn, :teacher_id) == teacher.id
    assert conn.assigns[:current_teacher] == Map.put(teacher, :password, nil)
  end

  test "does not login when account doesn't exist", %{conn: conn} do
    conn = conn |> post(session_path(conn, :create), Map.put(@valid_attrs, :email, "does@not.exist"))
    refute Plug.Conn.get_session(conn, :teacher_id)
  end

  test "does not login when password doesn't match", %{conn: conn} do
    conn = conn |> post(session_path(conn, :create), Map.put(@valid_attrs, :password, "invalid"))
    refute Plug.Conn.get_session(conn, :teacher_id)
  end

  test "logs out", %{conn: conn, teacher: teacher} do
    conn = conn |> with_current_teacher(teacher)
    assert TeacherSession.current_teacher(conn) == teacher
    conn = conn |> delete(session_path(conn, :delete))
    assert TeacherSession.current_teacher(conn) == nil
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
