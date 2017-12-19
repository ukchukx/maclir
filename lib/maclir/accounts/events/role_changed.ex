defmodule MacLir.Accounts.Events.RoleChanged do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :role,
  ]
end