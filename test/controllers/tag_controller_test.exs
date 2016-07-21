defmodule Kompax.TagControllerTest do
  use Kompax.ConnCase

  alias Kompax.Tag
  alias Kompax.Aspect

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    {:ok, aspect} = create_aspect
    conn = build_conn()
    {:ok, conn: conn, aspect: aspect}
  end

  defp create_aspect do
    Aspect.changeset(%Aspect{}, %{name: "some title", position: 1})
    |> Repo.insert
  end


  test "renders form for new resources", %{conn: conn, aspect: aspect} do
    conn = get conn, aspect_tag_path(conn, :new, aspect)
    assert html_response(conn, 200) =~ "New tag"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, aspect: aspect} do
    conn = post conn, aspect_tag_path(conn, :create, aspect), tag: @valid_attrs
    assert redirected_to(conn) == aspect_path(conn, :show, aspect)
    assert Repo.get_by(Tag, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, aspect: aspect} do
    conn = post conn, aspect_tag_path(conn, :create, aspect), tag: @invalid_attrs
    assert html_response(conn, 200) =~ "New tag"
  end

  test "renders form for editing chosen resource", %{conn: conn, aspect: aspect} do
    tag = build_assoc(aspect, :tags) |> Repo.insert!
    conn = get conn, aspect_tag_path(conn, :edit, aspect, tag)
    assert html_response(conn, 200) =~ "Edit tag"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, aspect: aspect} do
    tag = build_assoc(aspect, :tags) |> Repo.insert!
    conn = put conn, aspect_tag_path(conn, :update, aspect, tag), tag: @valid_attrs
    assert redirected_to(conn) == aspect_path(conn, :show, aspect)
    assert Repo.get_by(Tag, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, aspect: aspect} do
    tag = build_assoc(aspect, :tags) |> Repo.insert!
    conn = put conn, aspect_tag_path(conn, :update, aspect, tag), tag: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit tag"
  end

  test "deletes chosen resource", %{conn: conn, aspect: aspect} do
    tag = build_assoc(aspect, :tags) |> Repo.insert!
    conn = delete conn, aspect_tag_path(conn, :delete, aspect, tag)
    assert redirected_to(conn) == aspect_path(conn, :show, aspect)
    refute Repo.get(Tag, tag.id)
  end
end
