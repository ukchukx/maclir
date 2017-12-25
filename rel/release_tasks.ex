defmodule MacLir.Release.Tasks do
  @doc """
  This is a migration hook to work around Mix not being available in production.
  """

  def migrate do
    {:ok, _} = Application.ensure_all_started(:maclir)
    path = Application.app_dir(:maclir, "priv/repo/migrations")
    Ecto.Migrator.run(MacLir.Repo, path, :up, all: true)
  end
end