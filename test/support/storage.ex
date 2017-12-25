defmodule MacLir.Storage do
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    :ok = Application.stop(:maclir)
    :ok = Application.stop(:commanded)
    :ok = Application.stop(:eventstore)

    reset_eventstore()
    reset_readstore()

    {:ok, _} = Application.ensure_all_started(:maclir)
  end

  defp reset_eventstore do
    EventStore.configuration
    |> EventStore.Config.parse
    |> Postgrex.start_link
    |> elem(1)
    |> EventStore.Storage.Initializer.reset!
  end

  defp reset_readstore do
    :maclir
    |> Application.get_env(MacLir.Repo)
    |> Postgrex.start_link
    |> elem(1)
    |> Postgrex.query!(truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
      accounts_users,
      accounts_friends,
      projection_versions
    RESTART IDENTITY;
    """
  end
end