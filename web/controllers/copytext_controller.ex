defmodule Kompax.CopytextController do
  use Kompax.Web, :controller

  alias Kompax.Copytext

  plug :authenticate_user

  def index(conn, _params) do
    copytexts = Repo.all(Copytext)
    render(conn, "index.html", copytexts: copytexts)
  end

  def new(conn, _params) do
    changeset = Copytext.changeset(%Copytext{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"copytext" => copytext_params}) do
    changeset = Copytext.changeset(%Copytext{}, copytext_params)

    case Repo.insert(changeset) do
      {:ok, _copytext} ->
        conn
        |> put_flash(:info, "Copytext created successfully.")
        |> redirect(to: copytext_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    copytext = Repo.get!(Copytext, id)
    changeset = Copytext.changeset(copytext)
    render(conn, "edit.html", copytext: copytext, changeset: changeset)
  end

  def update(conn, %{"id" => id, "copytext" => copytext_params}) do
    copytext = Repo.get!(Copytext, id)
    changeset = Copytext.changeset(copytext, copytext_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Copytext updated successfully.")
        |> redirect(to: copytext_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", copytext: copytext, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    copytext = Repo.get!(Copytext, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(copytext)

    conn
    |> put_flash(:info, "Copytext deleted successfully.")
    |> redirect(to: copytext_path(conn, :index))
  end
end
