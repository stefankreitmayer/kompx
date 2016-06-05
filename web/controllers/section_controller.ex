defmodule Kompax.SectionController do
  use Kompax.Web, :controller

  alias Kompax.Section
  alias Kompax.Activity

  plug :scrub_params, "section" when action in [:create, :update]

  def index(conn, _params) do
    sections = Repo.all(Section)
    render(conn, "index.html", sections: sections)
  end

  def new(conn, %{"activity_id" => activity_id}) do
    activity = Repo.get!(Activity, activity_id)
    changeset = Section.changeset(%Section{})
    render(conn, "new.html", changeset: changeset, activity: activity)
  end

  def create(conn, %{"section" => section_params, "activity_id" => activity_id}) do
    activity = Repo.get!(Activity, activity_id)
    section = build_assoc(activity, :sections)
    changeset = Section.changeset(section, Map.merge(section_params, %{"position" => 7777}))
    case Repo.insert(changeset) do
      {:ok, _section} ->
        conn
        |> put_flash(:info, "Section created successfully.")
        |> redirect(to: activity_path(conn, :show, activity))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, activity: activity)
    end
  end

  def show(conn, %{"id" => id}) do
    section = Repo.get!(Section, id) |> Repo.preload(:activity)
    render(conn, "show.html", section: section)
  end

  def edit(conn, %{"id" => id}) do
    section = Repo.get!(Section, id) |> Repo.preload(:activity)
    changeset = Section.changeset(section)
    render(conn, "edit.html", changeset: changeset, section: section)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Repo.get!(Section, id) |> Repo.preload(:activity)
    activity = section.activity
    changeset = Section.changeset(section, section_params)
    case Repo.update(changeset) do
      {:ok, section} ->
        conn
        |> put_flash(:info, "Section updated successfully.")
        |> redirect(to: activity_section_path(conn, :show, activity, section))
      {:error, changeset} ->
        render(conn, "edit.html", section: section, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Repo.get!(Section, id) |> Repo.preload(:activity)
    activity = section.activity
    Repo.delete!(section)
    conn
    |> put_flash(:info, "Section deleted successfully.")
    |> redirect(to: activity_path(conn, :show, activity))
  end
end
