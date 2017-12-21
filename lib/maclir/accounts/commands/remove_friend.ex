defmodule MacLir.Accounts.Commands.RemoveFriend do
	defstruct [
    friend_uuid: "",
    to_uuid: "",
  ]

  use ExConstructor
  use Vex.Struct

  validates :friend_uuid, uuid: true
  validates :to_uuid, uuid: true
end