defmodule Kompax.Section do
  use Kompax.Web, :model

  schema "sections" do
    field :title, :string
    field :body, :string
    field :position, :integer
    belongs_to :activity, Kompax.Activity
    has_many :paragraphs, Kompax.Paragraph

    timestamps()
  end



  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(title body activity_id))
    |> validate_required(~w(title body)a)
  end
end
