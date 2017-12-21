defmodule MacLir.Accounts.Events.FriendAdded do
  @derive [Poison.Encoder]
  defstruct [
    :friend_uuid,
    :to_uuid,
  ]
end
