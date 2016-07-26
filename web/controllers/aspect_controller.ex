defmodule Kompax.AspectController do
  use Kompax.Web, :controller

  alias Kompax.Aspect
  alias Kompax.Tag

  def index(conn, _params) do
    query = from a in Aspect, order_by: a.position
    aspects = Repo.all(query)
    render(conn, "index.html", aspects: aspects)
  end

  def new(conn, _params) do
    changeset = Aspect.changeset(%Aspect{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"aspect" => aspect_params}) do
    changeset = Aspect.changeset(%Aspect{}, aspect_params)

    case Repo.insert(changeset) do
      {:ok, _aspect} ->
        conn
        |> put_flash(:info, "Aspect created successfully.")
        |> redirect(to: aspect_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    aspect = Repo.get!(Aspect, id)
              |> Repo.preload(tags: (from t in Tag, order_by: [asc: t.name]))
    render(conn, "show.html", aspect: aspect)
  end

  def edit(conn, %{"id" => id}) do
    aspect = Repo.get!(Aspect, id)
    changeset = Aspect.changeset(aspect)
    render(conn, "edit.html", aspect: aspect, changeset: changeset)
  end

  def update(conn, %{"id" => id, "aspect" => aspect_params}) do
    aspect = Repo.get!(Aspect, id)
    changeset = Aspect.changeset(aspect, aspect_params)

    case Repo.update(changeset) do
      {:ok, aspect} ->
        conn
        |> put_flash(:info, "Aspect updated successfully.")
        |> redirect(to: aspect_path(conn, :show, aspect))
      {:error, changeset} ->
        render(conn, "edit.html", aspect: aspect, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    aspect = Repo.get!(Aspect, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(aspect)

    conn
    |> put_flash(:info, "Aspect deleted successfully.")
    |> redirect(to: aspect_path(conn, :index))
  end
end
