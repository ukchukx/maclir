defmodule MacLir.Accounts.Workflows.RelayFriendEvents do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.RelayFriendEvents",
    consistency: :strong

  alias MacLir.Router
  alias MacLir.Accounts.Commands.{AcceptFriend,RemoveFriend}
  alias MacLir.Accounts.Events.{FriendAdded,FriendRemoved}
  alias __MODULE__.Cache

  def init do
    Cache.start_link()
    :ok
  end

  def handle(%FriendAdded{to_uuid: to, friend_uuid: friend}, %{causation_id: cause, correlation_id: corr}) do
    case Cache.seen?(corr) do
      true -> 
        Cache.remove(corr)
        :ok
      false ->
        Cache.store(corr)
        command = AcceptFriend.new(friend_uuid: to, to_uuid: friend)
        with :ok <- Router.dispatch(command, causation_id: cause, correlation_id: corr, consistency: :strong) do
          :ok
        else
          reply -> reply
        end
        
    end
  end

  def handle(%FriendRemoved{to_uuid: to, friend_uuid: friend}, %{causation_id: cause, correlation_id: corr}) do
    case Cache.seen?(corr) do
      true -> 
        Cache.remove(corr)
        :ok
      false ->
        Cache.store(corr)
        command = RemoveFriend.new(friend_uuid: to, to_uuid: friend)
        with :ok <- Router.dispatch(command, causation_id: cause, correlation_id: corr, consistency: :strong) do
          :ok
        else
          reply -> reply
        end        
    end
  end

  defmodule Cache do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, MapSet.new(), name: __MODULE__)
    end

    def store(corr_id) do
      GenServer.call(__MODULE__, {:store, corr_id})
    end

    def remove(corr_id) do
      GenServer.call(__MODULE__, {:remove, corr_id})
    end

    def seen?(corr_id) do
      GenServer.call(__MODULE__, {:find, corr_id})
    end

    def init(state), do: {:ok, state}

    def handle_call({:store, corr_id}, _from, set) do
      state = MapSet.put(set, corr_id)
      {:reply, state, state}
    end

    def handle_call({:remove, corr_id}, _from, set) do
      state = MapSet.delete(set, corr_id)
      {:reply, state, state}
    end

    def handle_call({:find, corr_id}, _from, set) do
      {:reply, MapSet.member?(set, corr_id), set}
    end
  end
end
