defmodule MacLir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :maclir,
      version: "1.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MacLir.Application, []},
      extra_applications: [:logger, :runtime_tools, :eventstore]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:cowboy, "~> 1.0"},
      {:commanded, "~> 0.15"},
      {:commanded_eventstore_adapter, "~> 0.3"},
      {:commanded_ecto_projections, "~> 0.6"},
      {:cors_plug, "~> 1.4"},
      {:distillery, "~> 1.5", runtime: false},
      {:exconstructor, "~> 1.1"},
      {:guardian, "~> 0.14"},
      {:ex_machina, "~> 2.0", only: :test},
      {:logger_file_backend, "~> 0.0.10"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:uuid, "~> 1.1"},
      {:vex, "~> 0.6"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "event_store.setup": ["event_store.create", "event_store.init"],
      "event_store.reset": ["event_store.drop", "event_store.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
