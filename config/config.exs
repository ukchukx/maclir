use Mix.Config

config :maclir,
  namespace: MacLir,
  ecto_repos: [MacLir.Repo]

config :commanded_ecto_projections,
  repo: MacLir.Repo

config :maclir, google_map_key: System.get_env("GMAP_KEY")

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

config :vex,
	sources: [
    MacLir.Accounts.Validators,
		MacLir.Support.Validators,
		Vex.Validators
	]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "MacLir",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "58R4E5dJY04t34JXiwv2mER9sJKjInIoj0VvryjVlTmkbD2rlstrf+o6QoRFCb37",
  serializer: MacLir.Auth.GuardianSerializer

import_config "#{Mix.env}.exs"
