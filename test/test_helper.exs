ExUnit.start

Mix.Task.run "ecto.create", ~w(-r TodoElixir.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r TodoElixir.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(TodoElixir.Repo)

