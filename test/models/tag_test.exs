defmodule Kompax.TagTest do
  use Kompax.ModelCase

  alias Kompax.Tag

  @valid_attrs %{name: "some content", aspect_id: 1234567}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "requires aspect_id" do
    changeset = Tag.changeset(%Tag{}, %{@valid_attrs | aspect_id: nil})
    refute changeset.valid?
  end
end
