defmodule Kompax.AspectTest do
  use Kompax.ModelCase

  alias Kompax.Aspect

  @valid_attrs %{name: "some content", position: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Aspect.changeset(%Aspect{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Aspect.changeset(%Aspect{}, @invalid_attrs)
    refute changeset.valid?
  end
end
