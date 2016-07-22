defmodule Kompax.Annotation do
  use Kompax.Web, :model

  schema "annotations" do
    belongs_to :activity, Kompax.Activity
    belongs_to :tag, Kompax.Tag

    timestamps()
  end
end
