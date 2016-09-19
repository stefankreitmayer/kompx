defmodule Kompax.SectionController do
  use Kompax.Web, :controller

  alias Kompax.Section
  alias Kompax.Activity

  import Ecto
  alias Ecto.Changeset

  plug :authenticate_user
  plug :scrub_params, "section" when action in [:create, :update]

  def new(conn, %{"activity_id" => activity_id}) do
    activity = Repo.get!(Activity, activity_id)
    changeset = Section.changeset(%Section{})
    render(conn, "new.html", changeset: changeset, activity: activity)
  end

  def create(conn, %{"section" => section_params, "activity_id" => activity_id}) do
    activity = Repo.get!(Activity, activity_id)
    section = build_assoc(activity, :sections)
    changeset = Section.changeset(section, section_params)
                |> position_at_end
    case Repo.insert(changeset) do
      {:ok, _section} ->
        conn
        |> put_flash(:info, "Section created successfully.")
        |> redirect(to: activity_path(conn, :show, activity))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, activity: activity)
    end
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
      {:ok, _section} ->
        conn
        |> put_flash(:info, "Section updated successfully.")
        |> redirect(to: activity_path(conn, :show, activity))
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

  def move(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)
    others = (from s in Section,
     where: s.activity_id==^section.activity_id,
     order_by: s.position) |> Repo.all
    successor = Enum.find(others, fn sec -> sec.position > section.position end)
    if successor do
      pos = successor.position
      Changeset.change(successor, position: section.position) |> Repo.update!
      Changeset.change(section, position: pos) |> Repo.update!
    end
    url = activity_path(conn, :show, section.activity_id)<>"#sections"
    conn
    |> redirect(to: url)
  end

  defp position_at_end(changeset) do
    changeset
    |> Changeset.force_change(:position, highest_existing_position+1)
  end

  defp highest_existing_position do
    positions = Repo.all(Section)
                |> Enum.map(fn section -> section.position end)
    if Enum.empty?(positions), do: 0, else: Enum.max(positions) || 0
  end
end
