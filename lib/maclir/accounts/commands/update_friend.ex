defmodule MacLir.Accounts.Commands.UpdateFriend do
	defstruct [
    friend_uuid: "",
    username: "",
  ]

  use ExConstructor
  use Vex.Struct

  validates :friend_uuid, uuid: true

  validates :username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z_0-9]+$/, message: "is invalid"],
    string: true
end