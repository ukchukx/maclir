defmodule Mix.Tasks.MacLir.Reset do
	use Mix.Task
	alias MacLir.Repo

	@shortdoc "Reset our read projections"
	def run(_) do
		reset_readmodel!()
	end


	# Clear the read store database & the subscriptions table in the event store database
  defp reset_readmodel! do
		Enum.each([:postgrex, :ecto], &Application.ensure_all_started/1)
		Repo.start_link()

		IO.puts "Resetting subscriptions..."
    reset_subscription_table()

		IO.puts "Resetting projections..."
    reset_readstore()

		IO.puts "Done"
  end

  defp reset_subscription_table do
    EventStore.configuration
    |> EventStore.Config.parse
    |> Postgrex.start_link
    |> elem(1)
    |> Postgrex.query(truncate_subscription_table(), [], pool: DBConnection.Poolboy)
  end

  defp reset_readstore do
    :maclir
    |> Application.get_env(Repo)
    |> Postgrex.start_link
    |> elem(1)
    |> Postgrex.query(truncate_readstore_tables(), [])
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

  defp truncate_subscription_table, do: "TRUNCATE TABLE subscriptions RESTART IDENTITY;"
end