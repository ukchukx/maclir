use Mix.Config

config :maclir,
  namespace: MacLir,
  ecto_repos: [MacLir.Repo]

# Configures the endpoint
config :maclir, MacLirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eMf+Iw9PjNeD8Mdkc66lztLWBnimouzqe41WnlwwhCrlAEfWHMjOWnKHAyynhZ8P",
  render_errors: [view: MacLirWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MacLir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :commanded,
 	event_store_adapter: Commanded.EventStore.Adapters.EventStore

import_config "#{Mix.env}.exs"
