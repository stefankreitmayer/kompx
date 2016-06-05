defmodule Kompax.SectionTest do
  use Kompax.ModelCase

  alias Kompax.Section

  @valid_attrs %{position: 42, title: "some content", activity_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Section.changeset(%Section{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Section.changeset(%Section{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "title required" do
    changeset = Section.changeset(%Section{}, Map.merge(@valid_attrs, %{title: ""}))
    refute changeset.valid?
  end
end
