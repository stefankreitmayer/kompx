defmodule Kompax.UserTest do
  use Kompax.ModelCase

  alias Kompax.User

  @valid_attrs %{email: "foo@bar.baz", password: "some content"}

  test "changeset, valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
    assert changeset.changes.password_hash
  end

  test "changeset, email missing" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :email))
    refute changeset.valid?
  end

  test "changeset, email invalid format" do
    changeset = User.changeset(%User{}, Map.put(@valid_attrs, :email, "not an email address"))
    refute changeset.valid?
  end

  test "changeset, password missing" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :password))
    refute changeset.valid?
  end

  test "changeset, password too short" do
    changeset = User.changeset(%User{}, Map.put(@valid_attrs, :password, "12345"))
    refute changeset.valid?
  end
end
