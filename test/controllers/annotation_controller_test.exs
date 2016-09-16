defmodule Kompax.AnnotationControllerTest do
  use Kompax.ConnCase

  alias Kompax.Annotation
  alias Kompax.Tag
  alias Kompax.Activity
  alias Kompax.TeacherFactory

  import Kompax.ConnCase, only: [with_current_teacher: 2]

  setup do
    conn = build_conn()
    activity = %Activity{title: "foo", summary: "bar", published: true} |> Repo.insert!
    tag = %Tag{name: "baz"} |> Repo.insert!
    {:ok,
     conn: conn,
     activity: activity,
     tag: tag}
  end

  defp request_as_teacher(conn, teacher, activity, tag) do
    conn |> with_current_teacher(teacher) |> post(annotation_path(conn, :toggle, %{activity_id: activity.id, tag_id: tag.id}))
  end

  describe "when logged in" do
    test "toggles annotation", %{conn: conn, activity: activity, tag: tag}  do
      teacher = TeacherFactory.create_teacher
      refute Repo.get_by(Annotation, %{activity_id: activity.id, tag_id: tag.id})
      conn |> request_as_teacher(teacher, activity, tag)
      assert Repo.get_by(Annotation, %{activity_id: activity.id, tag_id: tag.id})
      conn |> request_as_teacher(teacher, activity, tag)
      refute Repo.get_by(Annotation, %{activity_id: activity.id, tag_id: tag.id})
    end
  end

  describe "when not logged in" do
    test "rejects /toggle_annotation", %{conn: conn} do
      conn = post conn, annotation_path(conn, :toggle)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
