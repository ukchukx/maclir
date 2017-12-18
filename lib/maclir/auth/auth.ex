defmodule MacLir.Auth do
  @moduledoc """
  Boundary for authentication.
  Uses the bcrypt password hashing function.
  """

  alias Comeonin.Bcrypt

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User

  def authenticate_by_email(email, password) do
    with {:ok, user} <- user_by_email(email) do
      check_password(user, password)
		else
		 reply -> reply
		end
  end

  def authenticate_by_phone(phone, password) do
    with {:ok, user} <- user_by_phone(phone) do
      check_password(user, password)
		else
		 reply -> reply
		end
  end

  def hash_password(password), do: Bcrypt.hashpwsalt(password)
  def validate_password(password, hash), do: Bcrypt.checkpw(password, hash)

  defp user_by_email(email) do
    case Accounts.user_by_email(email) do
      nil -> {:error, :unauthenticated}
      user -> {:ok, user}
    end
  end

  defp user_by_phone(phone) do
    case Accounts.user_by_phone(phone) do
      nil -> {:error, :unauthenticated}
      user -> {:ok, user}
    end
  end

  defp check_password(%User{hashed_password: hashed_password} = user, password) do
    case validate_password(password, hashed_password) do
      true -> {:ok, user}
      _ -> {:error, :unauthenticated}
    end
  end
end