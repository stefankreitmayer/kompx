defmodule Kompax.ParagraphControllerTest do
  use Kompax.ConnCase

  alias Kompax.Paragraph
  alias Kompax.Section
  alias Kompax.Activity

  @valid_attrs %{body: "some content", bullet: true}
  @invalid_attrs %{}

  setup do
    {:ok, section} = create_section
    section = Repo.preload(section, :activity)
    conn = conn()
    {:ok, conn: conn, section: section}
  end

  defp create_section do
    {:ok, activity} = create_activity
    Section.changeset(%Section{}, %{title: "some content", activity_id: activity.id})
    |> Repo.insert
  end

  defp create_activity do
    Activity.changeset(%Activity{}, %{title: "some title", summary: "some text", published: true})
    |> Repo.insert
  end

  test "renders form for new resources", %{conn: conn, section: section} do
    conn = get conn, section_paragraph_path(conn, :new, section)
    assert html_response(conn, 200) =~ "New paragraph"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, section: section} do
    conn = post conn, section_paragraph_path(conn, :create, section), paragraph: @valid_attrs, section_id: section.id
    assert redirected_to(conn) == activity_section_path(conn, :show, section.activity, section)
    assert Repo.get_by(Paragraph, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, section: section} do
    conn = post conn, section_paragraph_path(conn, :create, section), paragraph: @invalid_attrs, section_id: section.id
    assert html_response(conn, 200) =~ "New paragraph"
  end

  test "renders form for editing chosen resource", %{conn: conn, section: section} do
    paragraph = Repo.insert! %Paragraph{section_id: section.id}
    conn = get conn, section_paragraph_path(conn, :edit, section, paragraph)
    assert html_response(conn, 200) =~ "Edit paragraph"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, section: section} do
    paragraph = Repo.insert! %Paragraph{section_id: section.id}
    conn = put conn, section_paragraph_path(conn, :update, section, paragraph), paragraph: @valid_attrs
    assert redirected_to(conn) == activity_section_path(conn, :show, section.activity, section)
    assert Repo.get_by(Paragraph, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, section: section} do
    paragraph = Repo.insert! %Paragraph{section_id: section.id}
    conn = put conn, section_paragraph_path(conn, :update, section, paragraph), paragraph: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit paragraph"
  end

  test "deletes chosen resource", %{conn: conn, section: section} do
    paragraph = Repo.insert! %Paragraph{}
    conn = delete conn, section_paragraph_path(conn, :delete, section, paragraph)
    assert redirected_to(conn) == activity_section_path(conn, :show, section.activity, section)
    refute Repo.get(Paragraph, paragraph.id)
  end
end
