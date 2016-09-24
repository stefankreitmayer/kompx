defmodule Kompax.Copytext do
  use Kompax.Web, :model

  schema "copytexts" do
    field :body, :string
    field :slug, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :slug])
    |> validate_required([:body, :slug])
    |> unique_constraint(:slug)
  end
end
