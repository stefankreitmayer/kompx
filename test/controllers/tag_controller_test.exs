defmodule Kompax.TagControllerTest do
  use Kompax.ConnCase

  alias Kompax.Tag
  alias Kompax.Aspect
  alias Kompax.TeacherFactory

  import Kompax.ConnCase, only: [with_current_teacher: 2]

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    aspect = create_aspect
    conn = build_conn()
    {:ok, conn: conn, aspect: aspect, teacher: TeacherFactory.create_teacher}
  end

  defp create_aspect do
    Aspect.changeset(%Aspect{}, %{name: "some title", position: 1})
    |> Repo.insert!
  end


  describe "when logged in" do
    test "renders form for new resources", %{conn: conn, aspect: aspect, teacher: teacher} do
      conn = conn |> with_current_teacher(teacher) |> get(aspect_tag_path(conn, :new, aspect))
      assert html_response(conn, 200) =~ "New tag"
    end

    test "creates resource and redirects when data is valid", %{conn: conn, aspect: aspect, teacher: teacher} do
      conn = conn |> with_current_teacher(teacher) |> post(aspect_tag_path(conn, :create, aspect), tag: @valid_attrs)
      assert redirected_to(conn) == aspect_path(conn, :show, aspect)
      assert Repo.get_by(Tag, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, aspect: aspect, teacher: teacher} do
      conn = conn |> with_current_teacher(teacher) |> post(aspect_tag_path(conn, :create, aspect), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "New tag"
    end

    test "renders form for editing chosen resource", %{conn: conn, aspect: aspect, teacher: teacher} do
      tag = build_assoc(aspect, :tags) |> Repo.insert!
      conn = conn |> with_current_teacher(teacher) |> get(aspect_tag_path(conn, :edit, aspect, tag))
      assert html_response(conn, 200) =~ "Edit tag"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, aspect: aspect, teacher: teacher} do
      tag = build_assoc(aspect, :tags) |> Repo.insert!
      conn = conn |> with_current_teacher(teacher) |> put(aspect_tag_path(conn, :update, aspect, tag), tag: @valid_attrs)
      assert redirected_to(conn) == aspect_path(conn, :show, aspect)
      assert Repo.get_by(Tag, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, aspect: aspect, teacher: teacher} do
      tag = build_assoc(aspect, :tags) |> Repo.insert!
      conn = conn |> with_current_teacher(teacher) |> put(aspect_tag_path(conn, :update, aspect, tag), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit tag"
    end

    test "deletes chosen resource", %{conn: conn, aspect: aspect, teacher: teacher} do
      tag = build_assoc(aspect, :tags) |> Repo.insert!
      conn = conn |> with_current_teacher(teacher) |> delete(aspect_tag_path(conn, :delete, aspect, tag))
      assert redirected_to(conn) == aspect_path(conn, :show, aspect)
      refute Repo.get(Tag, tag.id)
    end

    test "assigns ascending positions to new tags and moves them by swapping", %{conn: conn, aspect: aspect, teacher: teacher} do
      conn |> with_current_teacher(teacher) |> post(aspect_tag_path(conn, :create, aspect), tag: Map.put(@valid_attrs, :name, "a"))
      conn |> with_current_teacher(teacher) |> post(aspect_tag_path(conn, :create, aspect), tag: Map.put(@valid_attrs, :name, "b"))
      conn |> with_current_teacher(teacher) |> post(aspect_tag_path(conn, :create, aspect), tag: Map.put(@valid_attrs, :name, "c"))
      a = Repo.get_by(Tag, %{name: "a"})
      b = Repo.get_by(Tag, %{name: "b"})
      c = Repo.get_by(Tag, %{name: "c"})
      assert 1==a.position
      assert 2==b.position
      assert 3==c.position
      conn |> with_current_teacher(teacher) |> patch(aspect_tag_path(conn, :move, aspect, a))
      a = Repo.get!(Tag, a.id)
      b = Repo.get!(Tag, b.id)
      c = Repo.get!(Tag, c.id)
      assert 1==b.position
      assert 2==a.position
      assert 3==c.position
      conn |> with_current_teacher(teacher) |> patch(aspect_tag_path(conn, :move, aspect, a))
      a = Repo.get!(Tag, a.id)
      b = Repo.get!(Tag, b.id)
      c = Repo.get!(Tag, c.id)
      assert 1==b.position
      assert 2==c.position
      assert 3==a.position
    end

    test "trying to move the last tag has no effect", %{conn: conn, aspect: aspect, teacher: teacher} do
      a = Repo.insert! %Tag{aspect_id: aspect.id, position: 1}
      b = Repo.insert! %Tag{aspect_id: aspect.id, position: 2}
      c = Repo.insert! %Tag{aspect_id: aspect.id, position: 3}
      conn |> with_current_teacher(teacher) |> put(aspect_tag_path(conn, :move, aspect, c), tag: @valid_attrs)
      a = Repo.get!(Tag, a.id)
      b = Repo.get!(Tag, b.id)
      c = Repo.get!(Tag, c.id)
      assert 1==a.position
      assert 2==b.position
      assert 3==c.position
    end
  end

  describe "when not logged in" do
    test "rejects /new", %{conn: conn, aspect: aspect} do
      conn = get conn, aspect_tag_path(conn, :new, aspect)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /create", %{conn: conn, aspect: aspect} do
      conn = post conn, aspect_tag_path(conn, :create, aspect)
      assert redirected_to(conn) == session_path(conn, :create)
    end

    test "rejects /edit", %{conn: conn, aspect: aspect} do
      tag = Repo.insert! %Tag{name: "foo"}
      conn = get conn, aspect_tag_path(conn, :edit, aspect, tag)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /update", %{conn: conn, aspect: aspect} do
      tag = Repo.insert! %Tag{name: "foo"}
      conn = patch conn, aspect_tag_path(conn, :update, aspect, tag)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /delete", %{conn: conn, aspect: aspect} do
      tag = Repo.insert! %Tag{name: "foo"}
      conn = delete conn, aspect_tag_path(conn, :delete, aspect, tag)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
