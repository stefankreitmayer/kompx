ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Kompax.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Kompax.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Kompax.Repo)

