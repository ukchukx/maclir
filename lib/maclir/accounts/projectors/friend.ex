defmodule MacLir.Accounts.Projectors.Friend do
  use Commanded.Projections.Ecto, 
    name: "Accounts.Projectors.Friend",
    consistency: :strong

  alias MacLir.Accounts.Events.{
    FriendAdded,
    FriendCreated,
    FriendRequestRejected,
    FriendRemoved,
    FriendRequestCancelled,
    FriendRequestReceived
  }
  alias MacLir.Accounts.Projections.Friend
  alias MacLir.Accounts.Queries.FriendByUUID

  project %FriendCreated{} = friend do
    Ecto.Multi.insert(multi, :friend, %Friend{
      uuid: friend.friend_uuid,
      user_uuid: friend.user_uuid,
      username: friend.username,
      friends: [],
      received_requests: [],
    })
  end

  project %FriendAdded{friend_uuid: uuid, to_uuid: friend_uuid} do
    Ecto.Multi.update_all(multi, :friend, friend_query(uuid), 
      push: [friends: friend_uuid],
      pull: [received_requests: friend_uuid]
    )
  end

  project %FriendRequestRejected{friend_uuid: uuid, to_uuid: to_uuid} do
    Ecto.Multi.update_all(multi, :friend, friend_query(uuid), pull: [
      received_requests: to_uuid
    ])
  end

  project %FriendRemoved{friend_uuid: uuid, to_uuid: friend_uuid} do
    Ecto.Multi.update_all(multi, :friend, friend_query(uuid), pull: [
      friends: friend_uuid
    ])
  end

  project %FriendRequestCancelled{friend_uuid: uuid, from_uuid: friend_uuid} do
    Ecto.Multi.update_all(multi, :friend, friend_query(uuid), pull: [
      received_requests: friend_uuid
    ])
  end

  project %FriendRequestReceived{friend_uuid: uuid, from_uuid: friend_uuid} do
    Ecto.Multi.update_all(multi, :friend, friend_query(uuid), push: [
      received_requests: friend_uuid
    ])
  end


  defp friend_query(uuid), do: FriendByUUID.new(uuid)
end