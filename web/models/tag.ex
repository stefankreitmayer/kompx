defmodule Kompax.Tag do
  use Kompax.Web, :model

  schema "tags" do
    field :name, :string
    belongs_to :aspect, Kompax.Aspect

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :aspect_id])
    |> validate_required([:name])
    |> validate_required([:aspect_id])
    |> unique_constraint(:name)
  end
end
