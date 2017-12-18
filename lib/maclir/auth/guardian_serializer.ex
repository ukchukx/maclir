defmodule MacLir.Auth.GuardianSerializer do
  @moduledoc """
  Used by Guardian to serialize a JWT token
  """

  @behaviour Guardian.Serializer

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User

  def for_token(%User{} = user), do: {:ok, "User:#{user.uuid}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> uuid), do: {:ok, Accounts.user_by_uuid(uuid)}
  def from_token(_), do: {:error, "Unknown resource type"}
end