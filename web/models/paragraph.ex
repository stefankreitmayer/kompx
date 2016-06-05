defmodule Kompax.Paragraph do
  use Kompax.Web, :model

  schema "paragraphs" do
    field :body, :string
    field :position, :integer
    field :bullet, :boolean, default: false

    belongs_to :section, Kompax.Section

    timestamps
  end

  @required_fields ~w(body bullet section_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:body, min: 3)
  end
end
