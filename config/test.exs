use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :maclir, MacLirWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :comeonin, :bcrypt_log_rounds, 4


# Configure the event store database
config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "maclir_eventstore_test",
  hostname: "localhost",
  pool_size: 1

# Configure the read store database
config :maclir, MacLir.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "maclir_readstore_test",
  hostname: "localhost",
  pool_size: 1