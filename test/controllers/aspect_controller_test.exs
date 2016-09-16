defmodule Kompax.AspectControllerTest do
  use Kompax.ConnCase

  alias Kompax.Aspect
  alias Kompax.TeacherFactory

  import Kompax.ConnCase, only: [with_current_teacher: 2]

  @valid_attrs %{name: "some content", position: 42}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
    {:ok, conn: conn, teacher: TeacherFactory.create_teacher}
  end

  describe "when logged in" do
    test "lists all entries on index", %{conn: conn, teacher: teacher} do
      conn = conn |> with_current_teacher(teacher) |> get(aspect_path(conn, :index))
      assert html_response(conn, 200) =~ "All Aspects"
    end

    test "renders form for new resources", %{conn: conn, teacher: teacher} do
      conn = conn |> with_current_teacher(teacher) |> get(aspect_path(conn, :new))
      assert html_response(conn, 200) =~ "New aspect"
    end

    test "creates resource and redirects when data is valid", %{conn: conn, teacher: teacher} do
      conn = conn |> with_current_teacher(teacher) |> post(aspect_path(conn, :create), aspect: @valid_attrs)
      assert redirected_to(conn) == aspect_path(conn, :index)
      assert Repo.get_by(Aspect, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, teacher: teacher} do
      conn = conn |> with_current_teacher(teacher) |> post(aspect_path(conn, :create), aspect: @invalid_attrs)
      assert html_response(conn, 200) =~ "New aspect"
    end

    test "shows chosen resource", %{conn: conn, teacher: teacher} do
      aspect = Repo.insert! %Aspect{name: "Awesomeness"}
      conn = conn |> with_current_teacher(teacher) |> get(aspect_path(conn, :show, aspect))
      assert html_response(conn, 200) =~ "Aspect: Awesomeness"
    end

    test "renders page not found when id is nonexistent", %{conn: conn, teacher: teacher} do
      assert_error_sent 404, fn ->
        conn |> with_current_teacher(teacher) |> get(aspect_path(:show, -1))
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, teacher: teacher} do
      aspect = Repo.insert! %Aspect{}
      conn = conn |> with_current_teacher(teacher) |> get(aspect_path(conn, :edit, aspect))
      assert html_response(conn, 200) =~ "Edit aspect"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, teacher: teacher} do
      aspect = Repo.insert! %Aspect{}
      conn = conn |> with_current_teacher(teacher) |> put(aspect_path(conn, :update, aspect), aspect: @valid_attrs)
      assert redirected_to(conn) == aspect_path(conn, :show, aspect)
      assert Repo.get_by(Aspect, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, teacher: teacher} do
      aspect = Repo.insert! %Aspect{}
      conn = conn |> with_current_teacher(teacher) |> put(aspect_path(conn, :update, aspect), aspect: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit aspect"
    end

    test "deletes chosen resource", %{conn: conn, teacher: teacher} do
      aspect = Repo.insert! %Aspect{}
      conn = conn |> with_current_teacher(teacher) |> delete(aspect_path(conn, :delete, aspect))
      assert redirected_to(conn) == aspect_path(conn, :index)
      refute Repo.get(Aspect, aspect.id)
    end
  end

  describe "when not logged in" do
    test "rejects /index", %{conn: conn} do
      conn = get conn, aspect_path(conn, :index)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /new", %{conn: conn} do
      conn = get conn, aspect_path(conn, :new)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /create", %{conn: conn} do
      conn = post conn, aspect_path(conn, :create)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /show", %{conn: conn} do
      aspect = Repo.insert! %Aspect{name: "foo"}
      conn = get conn, aspect_path(conn, :show, aspect)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /edit", %{conn: conn} do
      aspect = Repo.insert! %Aspect{name: "foo"}
      conn = get conn, aspect_path(conn, :edit, aspect)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /update", %{conn: conn} do
      aspect = Repo.insert! %Aspect{name: "foo"}
      conn = patch conn, aspect_path(conn, :update, aspect)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /delete", %{conn: conn} do
      aspect = Repo.insert! %Aspect{name: "foo"}
      conn = delete conn, aspect_path(conn, :delete, aspect)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
