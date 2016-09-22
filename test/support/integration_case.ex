defmodule Kompax.IntegrationCase do
  use ExUnit.CaseTemplate
  using do
    quote do
      use Hound.Helpers

      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Kompax.Router.Helpers

      alias Kompax.Repo

      @endpoint Kompax.Endpoint

      hound_session
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kompax.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Kompax.Repo, {:shared, self()})
    end

    :ok
  end
end
