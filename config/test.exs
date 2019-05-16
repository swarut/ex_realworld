use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_realworld, ExRealworldWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ex_realworld, ExRealworld.Repo,
  username: System.get_env("REAL_WORLD_TEST_DB_USERNAME"),
  password: System.get_env("REAL_WORLD_TEST_DB_PASSWORD"),
  database: System.get_env("REAL_WORLD_TEST_DB"),
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :ex_realworld, ExRealworldWeb.UserToken,
  issuer: "ex_realworld",
  secret_key: "lhF2FI1RtyRltRwpTalZoU4I2NL+wkcdxW4kFiSspj+WVrXOXJZBT5MjZwzol5y5"
