defmodule Kompax.TeacherFactory do

  alias Kompax.Teacher
  alias Kompax.Repo

  def create_teacher do
    Teacher.changeset(%Teacher{}, %{email: "foo@bar.com", password: "s3cr3t"})
    |> Repo.insert!
  end
end
