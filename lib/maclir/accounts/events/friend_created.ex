defmodule MacLir.Accounts.Events.FriendCreated do
  @derive [Poison.Encoder]
  defstruct [
    :friend_uuid,
    :user_uuid,
    :username,
  ]
end
