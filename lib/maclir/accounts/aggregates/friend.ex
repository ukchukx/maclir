defmodule MacLir.Accounts.Aggregates.Friend do
  defstruct [
    uuid: nil,
    user_uuid: nil,
    username: nil,
    friends: MapSet.new(),
    sent_requests: MapSet.new(),
    received_requests: MapSet.new(),
  ]

  alias MacLir.Accounts.Commands.CreateFriend
  alias MacLir.Accounts.Events.FriendCreated

  @doc """
  Creates a friend
  """
  def execute(%__MODULE__{uuid: nil}, %CreateFriend{} = create) do
    %FriendCreated{
      friend_uuid: create.friend_uuid,
      user_uuid: create.user_uuid,
      username: create.username,
    }
  end

  # state mutators

  def apply(%__MODULE__{} = friend, %FriendCreated{} = created) do
    %Friend{friend |
      uuid: created.friend_uuid,
      user_uuid: created.user_uuid,
      username: created.username,
    }
  end
end
