defmodule Kompax.ParagraphController do
  use Kompax.Web, :controller

  alias Kompax.Paragraph
  alias Kompax.Section
  alias Kompax.Sequencer

  plug :scrub_params, "paragraph" when action in [:create, :update]

  def new(conn, %{"section_id" => section_id}) do
    section = Repo.get!(Section, section_id) |> Repo.preload(:activity)
    changeset = Paragraph.changeset(%Paragraph{section_id: section.id})
    render(conn, "new.html", changeset: changeset, section: section)
  end

  def create(conn, %{"paragraph" => paragraph_params, "section_id" => section_id}) do
    section = Repo.get!(Section, section_id) |> Repo.preload(:activity)
    paragraph = build_assoc(section, :paragraphs)
    changeset = Paragraph.changeset(paragraph, Map.merge(paragraph_params, %{"position" => "8888"}))
    case Repo.insert(changeset) do
      {:ok, _paragraph} ->
        conn
        |> put_flash(:info, "Paragraph created successfully.")
        |> redirect(to: activity_section_path(conn, :show, section.activity, section))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, section: section)
    end
  end

  def edit(conn, %{"id" => id}) do
    paragraph = Repo.get!(Paragraph, id) |> Repo.preload(section: :activity)
    changeset = Paragraph.changeset(paragraph)
    render(conn, "edit.html", paragraph: paragraph, changeset: changeset)
  end

  def update(conn, %{"id" => id, "paragraph" => paragraph_params}) do
    paragraph = Repo.get!(Paragraph, id) |> Repo.preload(section: :activity)
    changeset = Paragraph.changeset(paragraph, paragraph_params)
    case Repo.update(changeset) do
      {:ok, paragraph} ->
        conn
        |> put_flash(:info, "Paragraph updated successfully.")
        |> redirect(to: activity_section_path(conn, :show, paragraph.section.activity, paragraph.section))
      {:error, changeset} ->
        render(conn, "edit.html", paragraph: paragraph, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "section_id" => section_id}) do
    paragraph = Repo.get!(Paragraph, id)
    section = Repo.get!(Section, section_id) |> Repo.preload(:activity)
    Repo.delete!(paragraph)
    conn
    |> put_flash(:info, "Paragraph deleted successfully.")
    |> redirect(to: activity_section_path(conn, :show, section.activity, section))
  end

  def move(conn, %{"id" => id}) do
    paragraph = Repo.get!(Paragraph, id) |> Repo.preload(:section)
    section = paragraph.section |> Repo.preload([:paragraphs, :activity])
    section.paragraphs
    |> Sequencer.lower(id)
    |> Enum.each(fn({par, pos}) -> Repo.update!(Ecto.Changeset.change(par, %{position: pos})) end)
    conn
    # |> put_flash(:info, "Successfully changed the order of paragraphs.")
    |> redirect(to: activity_section_path(conn, :show, section.activity, section))
  end
end
