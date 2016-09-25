defmodule Kompax.Activity do
  use Kompax.Web, :model

  schema "activities" do
    field :title, :string
    field :summary, :string
    field :author, :string
    field :published, :boolean, default: false

    has_many :sections, Kompax.Section
    has_many :annotations, Kompax.Annotation, on_delete: :delete_all

    timestamps()
  end

  @allowed_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(title summary author published)a)
    |> validate_required(~w(title summary author published)a)
  end
end
