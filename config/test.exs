use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kompax, Kompax.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kompax, Kompax.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "kompax_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Reduce encryption in tests to improve speed
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
