defmodule Kompax.CopytextControllerTest do
  use Kompax.ConnCase

  alias Kompax.Copytext
  alias Kompax.UserFactory

  import Kompax.ConnCase, only: [with_current_user: 2]

  @valid_attrs %{body: "some content", slug: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
    {:ok, conn: conn, user: UserFactory.create_user}
  end

  describe "when logged in" do
    test "lists all entries on index", %{conn: conn, user: user} do
      conn = conn |> with_current_user(user) |> get(copytext_path(conn, :index))
      assert html_response(conn, 200) =~ "All Copytexts"
    end

    test "renders form for new resources", %{conn: conn, user: user} do
      conn = conn |> with_current_user(user) |> get(copytext_path(conn, :new))
      assert html_response(conn, 200) =~ "New copytext"
    end

    test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
      conn = conn |> with_current_user(user) |> post(copytext_path(conn, :create), copytext: @valid_attrs)
      assert redirected_to(conn) == copytext_path(conn, :index)
      assert Repo.get_by(Copytext, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> with_current_user(user) |> post(copytext_path(conn, :create), copytext: @invalid_attrs)
      assert html_response(conn, 200) =~ "New copytext"
    end

    test "renders form for editing chosen resource", %{conn: conn, user: user} do
      copytext = Repo.insert! %Copytext{}
      conn = conn |> with_current_user(user) |> get(copytext_path(conn, :edit, copytext))
      assert html_response(conn, 200) =~ "Edit copytext"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
      copytext = Repo.insert! %Copytext{}
      conn = conn |> with_current_user(user) |> put(copytext_path(conn, :update, copytext), copytext: @valid_attrs)
      assert redirected_to(conn) == copytext_path(conn, :index)
      assert Repo.get_by(Copytext, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
      copytext = Repo.insert! %Copytext{}
      conn = conn |> with_current_user(user) |> put(copytext_path(conn, :update, copytext), copytext: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit copytext"
    end

    test "deletes chosen resource", %{conn: conn, user: user} do
      copytext = Repo.insert! %Copytext{}
      conn = conn |> with_current_user(user) |> delete(copytext_path(conn, :delete, copytext))
      assert redirected_to(conn) == copytext_path(conn, :index)
      refute Repo.get(Copytext, copytext.id)
    end
  end

  describe "when not logged in" do
    test "rejects /index", %{conn: conn} do
      conn = get conn, copytext_path(conn, :index)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /new", %{conn: conn} do
      conn = get conn, copytext_path(conn, :new)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /create", %{conn: conn} do
      conn = post conn, copytext_path(conn, :create)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /edit", %{conn: conn} do
      copytext = Repo.insert! %Copytext{slug: "foo", body: "bar"}
      conn = get conn, copytext_path(conn, :edit, copytext)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /update", %{conn: conn} do
      copytext = Repo.insert! %Copytext{slug: "foo", body: "bar"}
      conn = patch conn, copytext_path(conn, :update, copytext)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /delete", %{conn: conn} do
      copytext = Repo.insert! %Copytext{slug: "foo", body: "bar"}
      conn = delete conn, copytext_path(conn, :delete, copytext)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
