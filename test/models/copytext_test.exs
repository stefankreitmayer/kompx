defmodule Kompax.CopytextTest do
  use Kompax.ModelCase

  alias Kompax.Copytext

  @valid_attrs %{body: "some content", slug: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Copytext.changeset(%Copytext{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Copytext.changeset(%Copytext{}, @invalid_attrs)
    refute changeset.valid?
  end
end
