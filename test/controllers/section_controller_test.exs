defmodule Kompax.SectionControllerTest do
  use Kompax.ConnCase

  alias Kompax.Section
  alias Kompax.Activity
  alias Kompax.Paragraph

  import Ecto

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  setup do
    {:ok, activity} = create_activity
    conn = conn()
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

  test "shows chosen resource", %{conn: conn, activity: activity} do
    section = Repo.insert! %Section{activity_id: activity.id}
    conn = get conn, activity_section_path(conn, :show, activity, section)
    assert html_response(conn, 200) =~ "Section"
    assert html_response(conn, 200) =~ "New paragraph"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, activity: activity} do
    assert_error_sent 404, fn ->
      get conn, activity_section_path(conn, :show, -1, activity)
    end
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
