defmodule MacLir.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :username,
    :role,
    :email,
    :phone,
    :latitude,
    :longitude,
    :hashed_password,
  ]

  alias MacLir.Accounts.Aggregates.User
  alias MacLir.Accounts.Commands.RegisterUser
  alias MacLir.Accounts.Events.UserRegistered

  @doc """
  Register a new user
  """
  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      user_uuid: register.user_uuid,
      username: register.username,
      role: register.role,
      email: register.email,
      phone: register.phone,
      latitude: register.latitude,
      longitude: register.longitude,
      hashed_password: register.hashed_password,
    }
  end

  # state mutators

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{user |
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      phone: registered.phone,
      latitude: registered.latitude,
      longitude: registered.longitude,
      hashed_password: registered.hashed_password,
    }
  end
end