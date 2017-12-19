defmodule MacLir.Accounts.Events.UsernameChanged do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :username,
  ]
end