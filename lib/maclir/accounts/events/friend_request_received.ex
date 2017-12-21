defmodule MacLir.Accounts.Events.FriendRequestReceived do
  @derive [Poison.Encoder]
  defstruct [
    :from_uuid,
    :friend_uuid,
  ]
end
