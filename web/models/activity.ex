defmodule Kompax.Activity do
  use Kompax.Web, :model

  schema "activities" do
    field :title, :string
    field :summary, :string
    field :published, :boolean, default: false

    has_many :sections, Kompax.Section

    timestamps
  end

  @required_fields ~w(title summary published)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:title, min: 3)
    |> validate_length(:summary, min: 3)
  end
end
