defmodule MacLirWeb.UserChannel do
	use MacLirWeb, :channel

	require Logger

  alias MacLirWeb.MyPresence
  alias MacLir.Accounts

  def join("user_presence:" <> _rest, _payload, _socket), do: {:error, %{reason: "unauthorized"}}

  def join("user:" <> user_uuid, _payload, socket) do
    if socket.assigns.user_uuid == user_uuid do
        send(self(), :after_join)
        {:ok, socket}
    else
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket = %{assigns: %{user_uuid: user_uuid}}) do
    friend_list = get_friend_list(user_uuid)
    Logger.debug("#{user_uuid}'s friends: " <> inspect(friend_list))
    presence_state = get_and_subscribe_presence_multi socket, friend_list
    push socket, "presence_state", presence_state
    {:ok, ref} = track_user_presence(user_uuid)
    {:noreply, Phoenix.Socket.assign(socket, :phx_ref, ref)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Send presence updates to subscribers
  def handle_in("presence:update", _payload, socket = %{assigns: %{user_uuid: user_uuid, phx_ref: ref}}) do
  	user_presence = %{user_uuid => %{metas: [%{online_at: :os.system_time(:milli_seconds), phx_ref: ref}]}}
    MacLirWeb.Endpoint.broadcast_from! self(), presence_topic(user_uuid), "presence_update", user_presence
    {:noreply, socket}
  end

  # Send location updates to subscribers
  def handle_in("location:update", payload, socket = %{assigns: %{user_uuid: user_uuid}}) do
    MacLirWeb.Endpoint.broadcast_from! self(), presence_topic(user_uuid), "location_update", payload
    {:noreply, socket}
  end

  # Track the current process as a presence for the given user on it's designated presence topic
  defp track_user_presence(user_uuid) do
    {:ok, _} = MyPresence.track(self(), presence_topic(user_uuid), user_uuid, %{
      online_at: :os.system_time(:milli_seconds)
    })
  end

  # Find the presence topics of all given users. Get their presence state and subscribe the current
  # process (channel) to their presence updates.
  defp get_and_subscribe_presence_multi(socket, user_uuids) do
    user_uuids
      |> Enum.map(&presence_topic/1)
      |> Enum.uniq
      |> Enum.map(fn topic ->
           :ok = Phoenix.PubSub.subscribe(
             socket.pubsub_server,
             topic,
             fastlane: {socket.transport_pid, socket.serializer, []}
           )
           MyPresence.list(topic)
         end)
      |> Enum.reduce(%{}, fn map, acc -> Map.merge(acc, map) end)
  end

  defp presence_topic(user_uuid), do: "user_presence:#{user_uuid}"

  defp get_friend_list(uuid), do: Accounts.user_friends(uuid) |> Enum.map(&(&1.user_uuid)) 
end