defmodule MacLir.Accounts.Events.FriendRequestRejected do
  @derive [Poison.Encoder]
  defstruct [
    :friend_uuid,
    :to_uuid,
  ]
end
