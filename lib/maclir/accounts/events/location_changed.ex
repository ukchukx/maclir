defmodule MacLir.Accounts.Events.LocationChanged do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :latitude,
    :longitude,
  ]
end