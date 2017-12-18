defmodule MacLir.Accounts.Events.UserRegistered do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :username,
    :role,
    :email,
    :phone,
    :latitude,
    :longitude,
    :hashed_password,
  ]
end