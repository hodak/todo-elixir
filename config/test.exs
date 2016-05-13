use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo_elixir, TodoElixir.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :todo_elixir, TodoElixir.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "hodak",
  password: "",
  database: "todo_elixir_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
