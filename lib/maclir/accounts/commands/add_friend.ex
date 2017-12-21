defmodule MacLir.Accounts.Commands.AddFriend do
	defstruct [
    from_uuid: "",
    friend_uuid: "",
  ]

  use ExConstructor
  use Vex.Struct

  validates :from_uuid, uuid: true
  validates :friend_uuid, uuid: true
end