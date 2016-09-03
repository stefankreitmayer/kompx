defmodule Kompax.TagController do
  use Kompax.Web, :controller

  alias Kompax.Tag
  alias Kompax.Aspect

  import Ecto
  alias Ecto.Changeset

  def new(conn, %{"aspect_id" => aspect_id}) do
    changeset = Tag.changeset(%Tag{})
    render(conn, "new.html", changeset: changeset, aspect_id: aspect_id)
  end

  def create(conn, %{"tag" => tag_params, "aspect_id" => aspect_id}) do
    aspect = Repo.get!(Aspect, aspect_id)
    changeset = Tag.changeset(%Tag{aspect_id: aspect.id}, tag_params)
                |> position_at_end

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
      {:ok, _} ->
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

  def move(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    others = (from s in Tag,
     where: s.aspect_id==^tag.aspect_id,
     order_by: s.position) |> Repo.all
    successor = Enum.find(others, fn t -> t.position > tag.position end)
    if successor do
      pos = successor.position
      Changeset.change(successor, position: tag.position) |> Repo.update!
      Changeset.change(tag, position: pos) |> Repo.update!
    end
    url = aspect_path(conn, :show, tag.aspect_id)<>"#tag"
    conn
    |> redirect(to: url)
  end

  defp position_at_end(changeset) do
    changeset
    |> Changeset.force_change(:position, highest_existing_position+1)
  end

  defp highest_existing_position do
    positions = Repo.all(Tag)
                |> Enum.map(fn tag -> tag.position end)
    if Enum.empty?(positions), do: 0, else: Enum.max(positions) || 0
  end
end
