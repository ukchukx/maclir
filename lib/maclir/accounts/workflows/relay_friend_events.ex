defmodule MacLir.Accounts.Workflows.RelayFriendEvents do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.RelayFriendEvents",
    consistency: :strong

  alias MacLir.Router
  alias MacLir.Accounts.Commands.{AcceptFriend,RemoveFriend}
  alias MacLir.Accounts.Events.{
    FriendAdded,
    FriendRemoved,
    FriendRequestRejected,
    FriendRequestCancelled,
    FriendRequestReceived
  }
  alias __MODULE__.Cache

  # TODO: Broadcast events to users

  def init do
    Cache.start_link()
    :ok
  end

  def handle(%FriendAdded{to_uuid: to, friend_uuid: friend}, %{causation_id: cause, correlation_id: corr}) do
    :ok
  end

  def handle(%FriendRemoved{to_uuid: to, friend_uuid: friend}, %{causation_id: cause, correlation_id: corr}) do
    :ok
  end

  def handle(%FriendRequestReceived{from_uuid: _from, friend_uuid: _friend}, _metadata) do
    :ok
  end

  def handle(%FriendRequestRejected{to_uuid: _to, friend_uuid: _friend}, _metadata) do
    :ok
  end

  def handle(%FriendRequestCancelled{from_uuid: _from, friend_uuid: _friend}, _metadata) do
    :ok
  end

end
