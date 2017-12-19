defmodule MacLir.Accounts.Events.UserEmailChanged do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :email,
  ]
end