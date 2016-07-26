defmodule Kompax.ActivityController do
  use Kompax.Web, :controller

  alias Kompax.Activity
  alias Kompax.Section
  alias Kompax.Aspect
  alias Kompax.Tag
  alias Ecto.Changeset

  plug :scrub_params, "activity" when action in [:create, :update]

  def index(conn, _params) do
    activities = (from a in Activity, order_by: a.title) |> Repo.all
    render(conn, "index.html", activities: activities)
  end

  def new(conn, _params) do
    changeset = Activity.changeset(%Activity{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"activity" => activity_params}) do
    changeset = Activity.changeset(%Activity{}, activity_params)
    |> Changeset.put_assoc(:sections, default_sections)
    case Repo.insert(changeset) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> redirect(to: activity_path(conn, :show, activity))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Repo.get!(Activity, id)
               |> Repo.preload([:annotations])
    sections = (from s in Section,
     where: s.activity_id == ^activity.id,
     order_by: s.position) |> Repo.all
    aspects = (from a in Aspect,
     order_by: a.position) |> Repo.all
                           |> Repo.preload(tags: (from t in Tag, order_by: [asc: t.name]))
    render(conn, "show.html", activity: activity, aspects: aspects, sections: sections)
  end

  def edit(conn, %{"id" => id}) do
    activity = Repo.get!(Activity, id)
    changeset = Activity.changeset(activity)
    render(conn, "edit.html", activity: activity, changeset: changeset)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Repo.get!(Activity, id)
    changeset = Activity.changeset(activity, activity_params)

    case Repo.update(changeset) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: activity_path(conn, :show, activity))
      {:error, changeset} ->
        render(conn, "edit.html", activity: activity, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Repo.get!(Activity, id)
    Repo.delete!(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: activity_path(conn, :index))
  end

  defp default_sections do
    [
      %Section{title: "Ziele", body: "TODO", position: 1},
      %Section{title: "Material", body: "TODO", position: 2},
      %Section{title: "Schritte", body: "TODO", position: 3}
    ]
  end
end
