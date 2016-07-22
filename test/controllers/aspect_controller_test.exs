defmodule Kompax.AspectControllerTest do
  use Kompax.ConnCase

  alias Kompax.Aspect
  @valid_attrs %{name: "some content", position: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, aspect_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing aspects"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, aspect_path(conn, :new)
    assert html_response(conn, 200) =~ "New aspect"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, aspect_path(conn, :create), aspect: @valid_attrs
    assert redirected_to(conn) == aspect_path(conn, :index)
    assert Repo.get_by(Aspect, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, aspect_path(conn, :create), aspect: @invalid_attrs
    assert html_response(conn, 200) =~ "New aspect"
  end

  test "shows chosen resource", %{conn: conn} do
    aspect = Repo.insert! %Aspect{name: "Awesomeness"}
    conn = get conn, aspect_path(conn, :show, aspect)
    assert html_response(conn, 200) =~ "Aspect: Awesomeness"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, aspect_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    aspect = Repo.insert! %Aspect{}
    conn = get conn, aspect_path(conn, :edit, aspect)
    assert html_response(conn, 200) =~ "Edit aspect"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    aspect = Repo.insert! %Aspect{}
    conn = put conn, aspect_path(conn, :update, aspect), aspect: @valid_attrs
    assert redirected_to(conn) == aspect_path(conn, :show, aspect)
    assert Repo.get_by(Aspect, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    aspect = Repo.insert! %Aspect{}
    conn = put conn, aspect_path(conn, :update, aspect), aspect: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit aspect"
  end

  test "deletes chosen resource", %{conn: conn} do
    aspect = Repo.insert! %Aspect{}
    conn = delete conn, aspect_path(conn, :delete, aspect)
    assert redirected_to(conn) == aspect_path(conn, :index)
    refute Repo.get(Aspect, aspect.id)
  end
end
