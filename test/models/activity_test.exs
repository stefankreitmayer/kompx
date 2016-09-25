defmodule Kompax.ActivityTest do
  use Kompax.ModelCase

  alias Kompax.Activity

  @valid_attrs %{published: true, summary: "some content", title: "some content", author: "J. Doe"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Activity.changeset(%Activity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Activity.changeset(%Activity{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "title required" do
    changeset = Activity.changeset(%Activity{}, Map.merge(@valid_attrs, %{title: ""}))
    refute changeset.valid?
  end

  test "summary required" do
    changeset = Activity.changeset(%Activity{}, Map.merge(@valid_attrs, %{summary: ""}))
    refute changeset.valid?
  end

  test "author required" do
    changeset = Activity.changeset(%Activity{}, Map.merge(@valid_attrs, %{author: ""}))
    refute changeset.valid?
  end
end
