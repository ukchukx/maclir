defmodule MacLir.Accounts.Events.FriendUpdated do
  @derive [Poison.Encoder]
  defstruct [
    :friend_uuid,
    :username,
  ]
end
