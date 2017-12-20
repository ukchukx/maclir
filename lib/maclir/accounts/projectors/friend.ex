defmodule MacLir.Accounts.Projectors.Friend do
  use Commanded.Projections.Ecto, 
    name: "Accounts.Projectors.Friend",
    consistency: :strong

  alias MacLir.Accounts.Events.FriendCreated
  alias MacLir.Accounts.Projections.Friend

  project %FriendCreated{} = friend do
    Ecto.Multi.insert(multi, :friend, %Friend{
      uuid: friend.friend_uuid,
      user_uuid: friend.user_uuid,
      username: friend.username,
      friends: [],
      sent_requests: [],
      received_requests: [],
    })
  end

end