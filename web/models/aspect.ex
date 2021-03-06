defmodule Kompax.Aspect do
  use Kompax.Web, :model

  schema "aspects" do
    field :name, :string
    field :position, :integer
    has_many :tags, Kompax.Tag, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :position])
    |> validate_required([:name, :position])
  end
end
