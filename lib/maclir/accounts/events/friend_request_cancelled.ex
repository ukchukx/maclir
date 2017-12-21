defmodule MacLir.Accounts.Events.FriendRequestCancelled do
  @derive [Poison.Encoder]
  defstruct [
    :from_uuid,
    :friend_uuid,
  ]
end
