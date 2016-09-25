defmodule Kompax.ActivityControllerTest do
  use Kompax.ConnCase

  alias Kompax.Activity
  alias Kompax.UserFactory

  import Kompax.ConnCase, only: [with_current_user: 2]


  @valid_attrs %{published: true, summary: "some content", title: "some content", author: "J. Doe"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
    {:ok, conn: conn, user: UserFactory.create_user}
  end

  describe "when logged in" do
    test "lists all entries on index", %{conn: conn, user: user} do
      conn =
        conn
        |> with_current_user(user)
        |> get(activity_path(conn, :index))
      assert html_response(conn, 200) =~ "All Activities"
    end

    test "renders form for new resources", %{conn: conn, user: user} do
      conn =
        conn
        |> with_current_user(user)
        |> get(activity_path(conn, :new))
      assert html_response(conn, 200) =~ "New activity"
    end

    test "creates activity with default sections and redirects when data is valid", %{conn: conn, user: user} do
      conn =
        conn
        |> with_current_user(user)
        |> post(activity_path(conn, :create), activity: @valid_attrs)
      activity = Repo.get_by(Activity, @valid_attrs)
      assert redirected_to(conn) == activity_path(conn, :show, activity)
      assert activity
      default_sections = Repo.preload(activity, :sections).sections
      titles = Enum.map(default_sections, fn(section) -> section.title end)
      assert(Enum.member? titles,"Ziele")
      assert(Enum.member? titles,"Material")
      assert(Enum.member? titles,"Unterrichtsschritte")
      default_sections |> Enum.map(fn(section) -> assert section.body=="TODO" end)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> with_current_user(user)
        |> post(activity_path(conn, :create), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "New activity"
    end

    test "shows chosen resource", %{conn: conn, user: user} do
      activity = Repo.insert! %Activity{title: "Jump for joy"}
      conn = conn
              |> with_current_user(user)
              |> get(activity_path(conn, :show, activity))
      assert html_response(conn, 200) =~ "Activity: Jump for joy"
    end

    test "renders page not found when id is nonexistent", %{conn: conn, user: user} do
      assert_error_sent 404, fn ->
        conn
        |> with_current_user(user)
        |> get(activity_path(conn, :show, -1))
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, user: user} do
      activity = Repo.insert! %Activity{}
      conn =
        conn
        |> with_current_user(user)
        |> get(activity_path(conn, :edit, activity))
      assert html_response(conn, 200) =~ "Edit activity"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
      activity = Repo.insert! %Activity{}
      conn =
        conn
        |> with_current_user(user)
        |> put(activity_path(conn, :update, activity), activity: @valid_attrs)
      assert redirected_to(conn) == activity_path(conn, :show, activity)
      assert Repo.get_by(Activity, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
      activity = Repo.insert! %Activity{}
      conn =
        conn
        |> with_current_user(user)
        |> put(activity_path(conn, :update, activity), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit activity"
    end

    test "deletes chosen resource", %{conn: conn, user: user} do
      activity = Repo.insert! %Activity{}
      conn =
        conn
        |> with_current_user(user)
        |> delete(activity_path(conn, :delete, activity))
      assert redirected_to(conn) == activity_path(conn, :index)
      refute Repo.get(Activity, activity.id)
    end
  end


  describe "when not logged in" do
    test "rejects /index", %{conn: conn} do
      conn = get conn, activity_path(conn, :index)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /new", %{conn: conn} do
      conn = get conn, activity_path(conn, :new)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /create", %{conn: conn} do
      conn = post conn, activity_path(conn, :create)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /show", %{conn: conn} do
      activity = Repo.insert! %Activity{title: "foo"}
      conn = get conn, activity_path(conn, :show, activity)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /edit", %{conn: conn} do
      activity = Repo.insert! %Activity{title: "foo"}
      conn = get conn, activity_path(conn, :edit, activity)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /update", %{conn: conn} do
      activity = Repo.insert! %Activity{title: "foo"}
      conn = patch conn, activity_path(conn, :update, activity)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /delete", %{conn: conn} do
      activity = Repo.insert! %Activity{title: "foo"}
      conn = delete conn, activity_path(conn, :delete, activity)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
