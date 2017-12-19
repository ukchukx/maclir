defmodule MacLir.Accounts.Events.UserPhoneChanged do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :phone,
  ]
end