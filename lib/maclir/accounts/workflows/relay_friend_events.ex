defmodule MacLir.Accounts.Workflows.RelayFriendEvents do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.RelayFriendEvents",
    consistency: :strong

  alias MacLir.Accounts.Events.{
    FriendAdded,
    FriendRemoved,
    FriendRequestRejected,
    FriendRequestCancelled,
    FriendRequestReceived
  }

  alias __MODULE__.Cache

  import MacLir.Support.Time, only: [recent?: 1, naive_to_datetime: 1]

  def init do
    Cache.start_link()
    :ok
  end


  def handle(%FriendAdded{to_uuid: to, friend_uuid: friend}, %{causation_id: cause_id, created_at: created_at}) do
    case Cache.seen?(cause_id) do
      true ->
        Cache.remove(cause_id)
        :ok
      false ->
        Cache.store(cause_id)

        created_at
        |> naive_to_datetime
        |> recent?
        |> case do
          false -> :ok
          true ->
            topic = user_topic(friend)
            payload = %{from: friend, to: to}
            broadcast(topic, "friend_added", payload)

            :ok
        end        
    end
  end

  def handle(%FriendRemoved{to_uuid: to, friend_uuid: friend}, %{causation_id: cause_id, created_at: created_at}) do
    case Cache.seen?(cause_id) do
      true ->
        Cache.remove(cause_id)
        :ok
      false ->
        Cache.store(cause_id)

        created_at
        |> naive_to_datetime
        |> recent?
        |> case do
          false -> :ok
          true ->
            topic = user_topic(friend)
            payload = %{from: friend, to: to}
            broadcast(topic, "friend_removed", payload)

            :ok
        end        
    end
  end

  def handle(%FriendRequestReceived{from_uuid: from, friend_uuid: friend}, %{created_at: created_at}) do
    created_at
    |> naive_to_datetime
    |> recent?
    |> case  do
      false -> :ok
      true ->
        topic = user_topic(friend)
        payload = %{to: friend, from: from}
        broadcast(topic, "friend_request_received", payload)

        :ok
    end
  end

  def handle(%FriendRequestRejected{to_uuid: to, friend_uuid: friend}, %{created_at: created_at}) do
    created_at
    |> naive_to_datetime
    |> recent?
    |> case  do
      false -> :ok
      true ->
        topic = user_topic(friend)
        payload = %{from: friend, to: to}
        broadcast(topic, "friend_request_rejected", payload)

        :ok
    end
  end

  def handle(%FriendRequestCancelled{from_uuid: from, friend_uuid: friend}, %{created_at: created_at}) do
    created_at
    |> naive_to_datetime
    |> recent?
    |> case  do
      false -> :ok
      true ->
        topic = user_topic(friend)
        payload = %{to: friend, from: from}
        broadcast(topic, "friend_request_cancelled", payload)

        :ok
    end
  end


  defp broadcast(topic, msg, payload) do
    alias MacLirWeb.Endpoint

    case Code.ensure_loaded?(Endpoint) do
      false -> :ok
      true -> Endpoint.broadcast!(topic, msg, payload)
    end
  end

  defp user_topic(uuid), do: "user:#{uuid}"

  defmodule Cache do
    use GenServer 
 
    def start_link, do: GenServer.start_link(__MODULE__, MapSet.new(), name: __MODULE__) 
 
    def store(id), do: GenServer.call(__MODULE__, {:store, id}) 
 
    def remove(id), do: GenServer.call(__MODULE__, {:remove, id}) 
 
    def seen?(id), do: GenServer.call(__MODULE__, {:find, id}) 
 
    def init(state), do: {:ok, state} 
 
    def handle_call({:store, id}, _from, set) do 
      state = MapSet.put(set, id) 
      {:reply, state, state} 
    end 
 
    def handle_call({:remove, id}, _from, set) do 
      state = MapSet.delete(set, id) 
      {:reply, state, state} 
    end 
 
    def handle_call({:find, id}, _from, set) do 
      {:reply, MapSet.member?(set, id), set} 
    end 
  end 
end
