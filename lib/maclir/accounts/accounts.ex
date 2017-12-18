defmodule MacLir.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  alias MacLir.Accounts.Commands.RegisterUser
  alias MacLir.Accounts.Queries.{UserByPhone,UserByUsername,UserByEmail}
  alias MacLir.Accounts.Projections.User
  alias MacLir.Repo
  alias MacLir.Router

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
  Get an existing user by their username, or return `nil` if not registered
  """
  def user_by_username(username) when is_binary(username) do
    username
    |> String.downcase
    |> UserByUsername.new
    |> Repo.one
  end

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

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

end
