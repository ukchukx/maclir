defmodule MacLir.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  alias MacLir.Accounts.Commands.{CreateFriend,RegisterUser,UpdateUser}
  alias MacLir.Accounts.Queries.{UserByPhone,UserByUsername,UserByEmail}
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
      |> RegisterUser.hash_password

    with :ok <- Router.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Create a friend.
  """
  def create_friend(attrs) do
    uuid = UUID.uuid4()

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

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
