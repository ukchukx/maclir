defmodule MacLir.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  alias MacLir.Accounts.Commands.{
    AddFriend,
    AcceptFriend,
    CancelFriend,
    CreateFriend,
    RejectFriend,
    RemoveFriend,
    RegisterUser,
    UpdateUser
  }

  alias MacLir.Accounts.Queries.{
    SentFriendRequests,
    UserByPhone,
    UserByUsername,
    UserByEmail
  }

  alias MacLir.Accounts.Projections.{Friend,User}
  alias MacLir.{Repo,Router}

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> RegisterUser.new
      |> RegisterUser.assign_uuid(uuid)
      |> RegisterUser.downcase_username
      |> RegisterUser.downcase_email
      |> RegisterUser.assign_dummy_email
      |> RegisterUser.hash_password

    with :ok <- Router.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Update the email, username, phone and/or password of a user.
  """
  def update_user(%User{uuid: user_uuid} = user, attrs \\ %{}) do
    update_user =
      attrs
      |> UpdateUser.new
      |> UpdateUser.assign_user(user)
      |> UpdateUser.downcase_username
      |> UpdateUser.downcase_email
      |> UpdateUser.hash_password

    with :ok <- Router.dispatch(update_user, consistency: :strong) do
      get(User, user_uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Create a friend.
  """
  def create_friend(%{user_uuid: uuid} = attrs) do
    create_friend =
      attrs
      |> CreateFriend.new
      |> CreateFriend.assign_uuid(uuid)

    with :ok <- Router.dispatch(create_friend, consistency: :strong) do
      get(Friend, uuid)
    else
      reply -> reply
    end
  end


  @doc """
  Add a friend
  """
  def add_friend(%Friend{uuid: uuid}, %Friend{uuid: uuid}), do: friend_by_uuid(uuid)

  def add_friend(%Friend{uuid: from_uuid}, %Friend{uuid: to_uuid}) do
    with :ok <- Router.dispatch(AddFriend.new(friend_uuid: to_uuid, from_uuid: from_uuid), consistency: :strong) do
      friend_by_uuid(from_uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Cancel a sent friend request
  """
  def cancel_friend(%Friend{uuid: uuid}, %Friend{uuid: uuid}), do: friend_by_uuid(uuid)

  def cancel_friend_request(%Friend{uuid: from_uuid}, %Friend{uuid: to_uuid}) do
    with :ok <- Router.dispatch(CancelFriend.new(friend_uuid: to_uuid, from_uuid: from_uuid), consistency: :strong) do
      friend_by_uuid(from_uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Accept a friend request
  """
  def accept_friend_request(%Friend{uuid: uuid}, %Friend{uuid: uuid}), do: friend_by_uuid(uuid)

  def accept_friend_request(%Friend{uuid: uuid}, %Friend{uuid: from_uuid}) do
    with :ok <- Router.dispatch(AcceptFriend.new(friend_uuid: uuid, to_uuid: from_uuid), consistency: :strong) do
      friend_by_uuid(uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Reject a friend request
  """
  def reject_friend_request(%Friend{uuid: uuid}, %Friend{uuid: uuid}), do: friend_by_uuid(uuid)

  def reject_friend_request(%Friend{uuid: from_uuid}, %Friend{uuid: to_uuid}) do
    with :ok <- Router.dispatch(RejectFriend.new(friend_uuid: from_uuid, to_uuid: to_uuid), consistency: :strong) do
      friend_by_uuid(from_uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Remove a friend
  """
  def remove_friend_request(%Friend{uuid: uuid}, %Friend{uuid: uuid}), do: friend_by_uuid(uuid)

  def remove_friend(%Friend{uuid: from_uuid}, %Friend{uuid: to_uuid}) do
    with :ok <- Router.dispatch(RemoveFriend.new(friend_uuid: from_uuid, to_uuid: to_uuid), consistency: :strong) do
      friend_by_uuid(from_uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Get an existing user by their username, or return `nil` if not registered
  """
  def user_by_username(username) when is_binary(username) do
    username
    |> String.downcase
    |> UserByUsername.new
    |> Repo.one
  end

  def user_by_username(_), do: nil

  @doc """
  Get a single user by their UUID
  """
  def user_by_uuid(uuid) when is_binary(uuid) do
    Repo.get(User, uuid)
  end

  @doc """
  Get an existing user by their phone number, or return `nil` if not registered
  """
  def user_by_phone(phone) do
    phone
    |> UserByPhone.new
    |> Repo.one
  end

  @doc """
  Get an existing user by their email, or return `nil` if not registered
  """
  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase
    |> UserByEmail.new
    |> Repo.one
  end

  def user_by_email(_), do: nil

  @doc """
  Get friends user has sent friend requests to
  """
  def user_sent_requests(user_uuid) do
    user_uuid
    |> friend_by_uuid
    |> load_sent_requests
    |> Map.get(:sent_requests)
    |> Enum.map(&friend_by_uuid/1)
  end

  @doc """
  Get friends user has sent friend requests to
  """
  def user_received_requests(user_uuid) do
    user_uuid
    |> friend_by_uuid
    |> Map.get(:received_requests)
    |> Enum.map(&friend_by_uuid/1)
  end

  @doc """
  Get user's friends
  """
  def user_friends(user_uuid) do
    user_uuid
    |> friend_by_uuid
    |> Map.get(:friends)
    |> Enum.map(&friend_by_uuid/1)
  end

  @doc """
  Get a single friend by their UUID
  """
  def friend_by_uuid(uuid) when is_binary(uuid) do
    Repo.get(Friend, uuid)
  end

  @doc """
  Get an existing friend by their user UUID, or return `nil` if not found
  """
  def friend_by_user(user_uuid), do: friend_by_uuid(user_uuid)

  @doc """
  Load sent requests into virtual field
  """
  def load_sent_requests(%Friend{uuid: uuid} = friend) do
    sent_requests = 
      uuid
      |> SentFriendRequests.new
      |> Repo.all
      |> Enum.map(&(&1.uuid))

    %Friend{friend | sent_requests: sent_requests}
  end
  def load_sent_requests(something_else), do: something_else

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
