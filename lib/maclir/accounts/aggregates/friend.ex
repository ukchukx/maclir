defmodule MacLir.Accounts.Aggregates.Friend do
  defstruct [
    uuid: nil,
    user_uuid: nil,
    username: nil,
    friends: MapSet.new(),
    received_requests: MapSet.new(),
  ]

  alias MacLir.Accounts.Commands.{
    AcceptFriend,
    AddFriend,
    CancelFriend,
    CreateFriend,
    RejectFriend,
    RemoveFriend,
    UpdateFriend,
  }

  alias MacLir.Accounts.Events.{
    FriendAdded,
    FriendCreated,
    FriendRequestRejected,
    FriendRemoved,
    FriendRequestCancelled,
    FriendRequestReceived,
    FriendUpdated,
  }
  alias MacLir.Accounts
  alias Commanded.Aggregate.Multi

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

  @doc """
  Updates a friend
  """
  def execute(%__MODULE__{uuid: uuid}, %UpdateFriend{username: username}) do
    %FriendUpdated{friend_uuid: uuid, username: username}
  end

  @doc """
  Add a friend
  """
  def execute(%__MODULE__{received_requests: reqs, uuid: uuid} = friend, %AddFriend{from_uuid: from_uuid}) do
    case is_friend?(from_uuid, friend) do
      true -> nil
      false ->
        case Enum.member?(reqs, from_uuid) do
          false -> %FriendRequestReceived{from_uuid: from_uuid, friend_uuid: uuid}
          true -> nil
        end        
    end
  end

  @doc """
  Cancel a friend request
  """
  def execute(%__MODULE__{received_requests: reqs, uuid: friend_uuid} = friend, %CancelFriend{from_uuid: requester}) do
    case is_friend?(requester, friend) do
      true -> nil
      false ->
        case Enum.member?(reqs, requester) do
          false -> nil
          true -> %FriendRequestCancelled{friend_uuid: friend_uuid, from_uuid: requester}
        end        
    end
  end

  @doc """
  Accept a friend request
  """
  def execute(%__MODULE__{received_requests: reqs, uuid: uuid} = friend, %AcceptFriend{to_uuid: to_uuid}) do
    case is_friend?(to_uuid, friend) do
      true -> nil
      false -> 
        case Enum.member?(reqs, to_uuid) or is_friend?(to_uuid, uuid) do
          true -> 
            friend
            |> Multi.new
            |> Multi.execute(&friend_added(&1, uuid, to_uuid))
            |> Multi.execute(&friend_added(&1, to_uuid, uuid))
          false -> nil
        end        
    end
  end

  @doc """
  Reject a friend request
  """
  def execute(%__MODULE__{received_requests: reqs, uuid: friend_uuid} = friend, %RejectFriend{to_uuid: to_uuid}) do
    case is_friend?(to_uuid, friend) do
      true -> nil
      false ->
        case Enum.member?(reqs, to_uuid) do
          true -> %FriendRequestRejected{friend_uuid: friend_uuid, to_uuid: to_uuid}
          false -> nil
        end
    end
  end

  @doc """
  Remove a friend
  """
  def execute(%__MODULE__{uuid: friend_uuid} = friend, %RemoveFriend{to_uuid: to_uuid}) do
    case is_friend?(to_uuid, friend) do
      true -> 
        friend
        |> Multi.new
        |> Multi.execute(&friend_removed(&1, friend_uuid, to_uuid))
        |> Multi.execute(&friend_removed(&1, to_uuid, friend_uuid))
      false -> nil
    end
  end

  # state mutators

  def apply(%__MODULE__{} = friend, %FriendCreated{} = created) do
    %__MODULE__{friend |
      uuid: created.friend_uuid,
      user_uuid: created.user_uuid,
      username: created.username,
    }
  end

  def apply(%__MODULE__{} = friend, %FriendUpdated{username: username}) do
    %__MODULE__{friend | username: username}
  end

  def apply(%__MODULE__{received_requests: reqs} = friend, %FriendRequestReceived{from_uuid: from_uuid}) do
    %__MODULE__{friend | received_requests: MapSet.put(reqs, from_uuid)}
  end

  def apply(%__MODULE__{received_requests: reqs} = friend, %FriendRequestCancelled{from_uuid: from_uuid}) do
    %__MODULE__{friend | received_requests: MapSet.delete(reqs, from_uuid)}
  end

  def apply(%__MODULE__{friends: friends, received_requests: reqs} = friend, %FriendAdded{to_uuid: to_uuid}) do
    %__MODULE__{friend | 
      friends: MapSet.put(friends, to_uuid), 
      received_requests: MapSet.delete(reqs, to_uuid)}
  end

  def apply(%__MODULE__{received_requests: reqs} = friend, %FriendRequestRejected{to_uuid: to_uuid}) do
    %__MODULE__{friend | received_requests: MapSet.delete(reqs, to_uuid)}
  end

  def apply(%__MODULE__{friends: friends} = friend, %FriendRemoved{to_uuid: to_uuid}) do
    %__MODULE__{friend | friends: MapSet.delete(friends, to_uuid)}
  end

  # private helpers

  defp friend_added(_, friend, to), do: %FriendAdded{friend_uuid: friend, to_uuid: to}

  defp friend_removed(_, friend, to), do: %FriendRemoved{friend_uuid: friend, to_uuid: to}

  defp is_friend?(friend_uuid, %__MODULE__{friends: friends}) do
    Enum.member?(friends, friend_uuid)
  end
  defp is_friend?(friend_uuid, uuid) do
    %{friends: friends} = Accounts.friend_by_uuid(friend_uuid)
    Enum.member?(friends, uuid)
  end
end
