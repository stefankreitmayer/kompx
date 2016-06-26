defmodule Kompax.ActivityControllerTest do
  use Kompax.ConnCase

  alias Kompax.Activity
  @valid_attrs %{published: true, summary: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, activity_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing activities"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, activity_path(conn, :new)
    assert html_response(conn, 200) =~ "New activity"
  end

  test "creates activity with default sections and redirects when data is valid", %{conn: conn} do
    conn = post conn, activity_path(conn, :create), activity: @valid_attrs
    assert redirected_to(conn) == activity_path(conn, :index)
    activity = Repo.get_by(Activity, @valid_attrs)
    assert activity
    default_sections = Repo.preload(activity, :sections).sections
    titles = Enum.map(default_sections, fn(section) -> section.title end)
    assert(Enum.member? titles,"Ziele")
    assert(Enum.member? titles,"Material")
    assert(Enum.member? titles,"Schritte")
    default_sections |> Enum.map(fn(section) -> assert section.body=="TODO" end)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, activity_path(conn, :create), activity: @invalid_attrs
    assert html_response(conn, 200) =~ "New activity"
  end

  test "shows chosen resource", %{conn: conn} do
    activity = Repo.insert! %Activity{title: "Jump for joy"}
    conn = get conn, activity_path(conn, :show, activity)
    assert html_response(conn, 200) =~ "Activity: Jump for joy"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, activity_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = get conn, activity_path(conn, :edit, activity)
    assert html_response(conn, 200) =~ "Edit activity"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = put conn, activity_path(conn, :update, activity), activity: @valid_attrs
    assert redirected_to(conn) == activity_path(conn, :show, activity)
    assert Repo.get_by(Activity, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = put conn, activity_path(conn, :update, activity), activity: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit activity"
  end

  test "deletes chosen resource", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = delete conn, activity_path(conn, :delete, activity)
    assert redirected_to(conn) == activity_path(conn, :index)
    refute Repo.get(Activity, activity.id)
  end
end
