defmodule MacLir.Accounts.Commands.CreateFriend do
	defstruct [
    friend_uuid: "",
    user_uuid: "",
    username: "",
  ]

  use ExConstructor
  use Vex.Struct

  validates :friend_uuid, uuid: true

  validates :user_uuid, uuid: true

  validates :username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z_0-9]+$/, message: "is invalid"],
    string: true

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%__MODULE__{} = create_friend, uuid) do
    %__MODULE__{create_friend | friend_uuid: uuid}
  end
end