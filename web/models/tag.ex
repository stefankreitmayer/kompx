defmodule Kompax.Tag do
  use Kompax.Web, :model

  schema "tags" do
    field :name, :string
    field :position, :integer
    belongs_to :aspect, Kompax.Aspect

    has_many :annotations, Kompax.Annotation, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :aspect_id, :position])
    |> validate_required([:name])
    |> validate_required([:aspect_id])
  end
end
