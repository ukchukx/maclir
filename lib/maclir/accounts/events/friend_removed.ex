defmodule MacLir.Accounts.Events.FriendRemoved do
  @derive [Poison.Encoder]
  defstruct [
    :friend_uuid,
    :to_uuid,
  ]
end
