use Mix.Config


config :maclir, MacLirWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info


config :maclir, MacLirWeb.Endpoint,
  secret_key_base: "BqvCQ7OJrQ42c5ifiM/UvZpKQJOmu/L+EtmaYyhfGZ2FFt9GVqkuJa6UqLHlLqRu"


# Configure the event store database
config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASS"),
  database: "maclir_eventstore_prod",
  hostname: "localhost",
  pool_size: 10

# Configure the read store database
config :maclir, MacLir.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASS"),
  database: "maclir_readstore_prod",
  hostname: "localhost",
  pool_size: 15