defmodule Kompax.UserFactory do

  alias Kompax.User
  alias Kompax.Repo

  def create_user do
    User.changeset(%User{}, %{email: "foo@bar.com", password: "s3cr3t"})
    |> Repo.insert!
  end
end
