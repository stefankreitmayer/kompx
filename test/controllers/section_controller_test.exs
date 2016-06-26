defmodule Kompax.SectionControllerTest do
  use Kompax.ConnCase

  alias Kompax.Section
  alias Kompax.Activity

  @valid_attrs %{title: "some content", body: "some plain text"}
  @invalid_attrs %{}

  setup do
    {:ok, activity} = create_activity
    conn = build_conn()
    {:ok, conn: conn, activity: activity}
  end

  defp create_activity do
    Activity.changeset(%Activity{}, %{title: "some title", summary: "some text", published: true})
    |> Repo.insert
  end

  test "renders form for new resources", %{conn: conn, activity: activity} do
    conn = get conn, activity_section_path(conn, :new, activity)
    assert html_response(conn, 200) =~ "New section"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, activity: activity} do
    conn = post conn, activity_section_path(conn, :create, activity), section: @valid_attrs
    section = Repo.get_by(Section, @valid_attrs)
    assert section
    assert redirected_to(conn) == activity_path(conn, :show, activity)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, activity: activity} do
    conn = post conn, activity_section_path(conn, :create, activity), section: @invalid_attrs
    assert html_response(conn, 200) =~ "New section"
  end

  test "renders form for editing chosen resource", %{conn: conn, activity: activity} do
    section = Repo.insert! %Section{activity_id: activity.id}
    conn = get conn, activity_section_path(conn, :edit, activity, section)
    assert html_response(conn, 200) =~ "Edit section"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, activity: activity} do
    section = Repo.insert! %Section{activity_id: activity.id}
    conn = put conn, activity_section_path(conn, :update, activity, section), section: @valid_attrs
    assert redirected_to(conn) == activity_path(conn, :show, activity)
    assert Repo.get_by(Section, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: activity} do
    section = Repo.insert! %Section{activity_id: activity.id}
    conn = put conn, activity_section_path(conn, :update, activity, section), section: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit section"
  end

  test "deletes chosen resource", %{conn: conn, activity: activity} do
    section = Repo.insert! %Section{activity_id: activity.id}
    conn = delete conn, activity_section_path(conn, :delete, activity, section)
    assert redirected_to(conn) == activity_path(conn, :show, activity)
    refute Repo.get(Section, section.id)
  end
end
