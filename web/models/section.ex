defmodule Kompax.Section do
  use Kompax.Web, :model

  schema "sections" do
    field :title, :string
    field :position, :integer
    belongs_to :activity, Kompax.Activity

    timestamps
  end

  @required_fields ~w(title activity_id)
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
  end
end
