defmodule Kompax.ParagraphTest do
  use Kompax.ModelCase

  alias Kompax.Paragraph

  @valid_attrs %{body: "some content", bullet: true, position: 42, section_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Paragraph.changeset(%Paragraph{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Paragraph.changeset(%Paragraph{}, @invalid_attrs)
    refute changeset.valid?
  end
end
