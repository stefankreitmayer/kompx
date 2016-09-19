defmodule Kompax.SectionControllerTest do
  use Kompax.ConnCase

  alias Kompax.Section
  alias Kompax.Activity
  alias Kompax.UserFactory

  import Kompax.ConnCase, only: [with_current_user: 2]

  @valid_attrs %{title: "some content", body: "some plain text"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
    {:ok, conn: conn, activity: create_activity, user: UserFactory.create_user}
  end

  defp create_activity do
    Activity.changeset(%Activity{}, %{title: "some title", summary: "some text", published: true})
    |> Repo.insert!
  end

  describe "when logged in" do
    test "renders form for new resources", %{conn: conn, activity: activity, user: user} do
      conn = conn |> with_current_user(user)
      conn = get conn, activity_section_path(conn, :new, activity)
      assert html_response(conn, 200) =~ "New section"
    end

    test "creates resource and redirects when data is valid", %{conn: conn, activity: activity, user: user} do
      conn = conn |> with_current_user(user)
      conn = post conn, activity_section_path(conn, :create, activity), section: @valid_attrs
      section = Repo.get_by(Section, @valid_attrs)
      assert section
      assert redirected_to(conn) == activity_path(conn, :show, activity)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, activity: activity, user: user} do
      conn = conn |> with_current_user(user)
      conn = post conn, activity_section_path(conn, :create, activity), section: @invalid_attrs
      assert html_response(conn, 200) =~ "New section"
    end

    test "renders form for editing chosen resource", %{conn: conn, activity: activity, user: user} do
      conn = conn |> with_current_user(user)
      section = Repo.insert! %Section{activity_id: activity.id}
      conn = get conn, activity_section_path(conn, :edit, activity, section)
      assert html_response(conn, 200) =~ "Edit section"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, activity: activity, user: user} do
      section = Repo.insert! %Section{activity_id: activity.id}
      conn = conn |> with_current_user(user)
      conn = put conn, activity_section_path(conn, :update, activity, section), section: @valid_attrs
      assert redirected_to(conn) == activity_path(conn, :show, activity)
      assert Repo.get_by(Section, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: activity, user: user} do
      section = Repo.insert! %Section{activity_id: activity.id}
      conn = conn |> with_current_user(user)
      conn = put conn, activity_section_path(conn, :update, activity, section), section: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit section"
    end

    test "deletes chosen resource", %{conn: conn, activity: activity, user: user} do
      section = Repo.insert! %Section{activity_id: activity.id}
      conn = conn |> with_current_user(user)
      conn = delete conn, activity_section_path(conn, :delete, activity, section)
      assert redirected_to(conn) == activity_path(conn, :show, activity)
      refute Repo.get(Section, section.id)
    end

    test "assigns ascending positions to new sections and moves them by swapping", %{conn: conn, activity: activity, user: user} do
      conn = conn |> with_current_user(user)
      post conn, activity_section_path(conn, :create, activity), section: Map.put(@valid_attrs, :title, "a")
      post conn, activity_section_path(conn, :create, activity), section: Map.put(@valid_attrs, :title, "b")
      post conn, activity_section_path(conn, :create, activity), section: Map.put(@valid_attrs, :title, "c")
      a = Repo.get_by(Section, %{title: "a"})
      b = Repo.get_by(Section, %{title: "b"})
      c = Repo.get_by(Section, %{title: "c"})
      assert 1==a.position
      assert 2==b.position
      assert 3==c.position
      patch conn, activity_section_path(conn, :move, activity, a)
      a = Repo.get!(Section, a.id)
      b = Repo.get!(Section, b.id)
      c = Repo.get!(Section, c.id)
      assert 1==b.position
      assert 2==a.position
      assert 3==c.position
      patch conn, activity_section_path(conn, :move, activity, a)
      a = Repo.get!(Section, a.id)
      b = Repo.get!(Section, b.id)
      c = Repo.get!(Section, c.id)
      assert 1==b.position
      assert 2==c.position
      assert 3==a.position
    end

    test "trying to move the last section has no effect", %{conn: conn, activity: activity, user: user} do
      a = Repo.insert! %Section{activity_id: activity.id, position: 1}
      b = Repo.insert! %Section{activity_id: activity.id, position: 2}
      c = Repo.insert! %Section{activity_id: activity.id, position: 3}
      conn = conn |> with_current_user(user)
      put conn, activity_section_path(conn, :move, activity, c), section: @valid_attrs
      a = Repo.get!(Section, a.id)
      b = Repo.get!(Section, b.id)
      c = Repo.get!(Section, c.id)
      assert 1==a.position
      assert 2==b.position
      assert 3==c.position
    end
  end

  describe "when not logged in" do
    test "rejects /new", %{conn: conn, activity: activity} do
      conn = get conn, activity_section_path(conn, :new, activity)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /create", %{conn: conn, activity: activity} do
      conn = post conn, activity_section_path(conn, :create, activity)
      assert redirected_to(conn) == session_path(conn, :create)
    end

    test "rejects /edit", %{conn: conn, activity: activity} do
      section = Repo.insert! %Section{title: "foo", body: "bar"}
      conn = get conn, activity_section_path(conn, :edit, activity, section)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /update", %{conn: conn, activity: activity} do
      section = Repo.insert! %Section{title: "foo", body: "bar"}
      conn = patch conn, activity_section_path(conn, :update, activity, section)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "rejects /delete", %{conn: conn, activity: activity} do
      section = Repo.insert! %Section{title: "foo", body: "bar"}
      conn = delete conn, activity_section_path(conn, :delete, activity, section)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
