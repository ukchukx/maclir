use Mix.Config

config :maclir, env: :prod

config :maclir, MacLirWeb.Endpoint,
  load_from_system_env: false,
  http: [port: System.get_env("MACLIR_PORT"), compress: true],
  url: [host: "https://maclir.com.ng", port: 80],
  server: true,
  check_origin: ["https://maclir.com.ng"],
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json",
  version: Application.spec(:maclir, :vsn)

config :logger, level: :info


config :logger,
  backends: [{LoggerFileBackend, :info},
             {LoggerFileBackend, :warn},
             {LoggerFileBackend, :error}]

config :logger, :warn,
  path: "logs/warn.log",
  format: "[$date] [$time] [$level] $metadata $levelpad$message\n",
  metadata: [:date, :module, :line],
  level: :warn

config :logger, :error,
  path: "logs/error.log",
  format: "[$date] [$time] [$level] $metadata $levelpad$message\n",
  metadata: [:date, :module, :line],
  level: :error

config :logger, :info,
  path: "logs/info.log",
  format: "[$date] [$time] [$level] $metadata $levelpad$message\n",
  metadata: [:date, :application, :module, :function, :line],
  level: :info


config :maclir, MacLirWeb.Endpoint,
  secret_key_base: "BqvCQ7OJrQ42c5ifiM/UvZpKQJOmu/L+EtmaYyhfGZ2FFt9GVqkuJa6UqLHlLqRu"


# Configure the event store database
config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASS"),
  database: "maclir_eventstore",
  hostname: "localhost",
  pool_size: 10

# Configure the read store database
config :maclir, MacLir.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASS"),
  database: "maclir_readstore",
  hostname: "localhost",
  pool_size: 15