defmodule Kompax.TagController do
  use Kompax.Web, :controller

  alias Kompax.Tag
  alias Kompax.Aspect

  def new(conn, %{"aspect_id" => aspect_id}) do
    changeset = Tag.changeset(%Tag{})
    render(conn, "new.html", changeset: changeset, aspect_id: aspect_id)
  end

  def create(conn, %{"tag" => tag_params, "aspect_id" => aspect_id}) do
    aspect = Repo.get!(Aspect, aspect_id)
    changeset = Tag.changeset(%Tag{aspect_id: aspect.id}, tag_params)

    case Repo.insert(changeset) do
      {:ok, _tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: aspect_path(conn, :show, aspect_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, aspect_id: aspect_id)
    end
  end

  def edit(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag)
    render(conn, "edit.html", tag: tag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tag" => tag_params, "aspect_id" => aspect_id}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag, tag_params)

    case Repo.update(changeset) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: aspect_path(conn, :show, aspect_id))
      {:error, changeset} ->
        render(conn, "edit.html", tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "aspect_id" => aspect_id}) do
    tag = Repo.get!(Tag, id)
    Repo.delete!(tag)
    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: aspect_path(conn, :show, aspect_id))
  end
end
