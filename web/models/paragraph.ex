defmodule Kompax.Paragraph do
  use Kompax.Web, :model

  schema "paragraphs" do
    field :body, :string
    field :position, :integer
    field :bullet, :boolean, default: false

    belongs_to :section, Kompax.Section

    timestamps
  end


  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(body bullet section_id))
    |> validate_required([:body])
  end
end
