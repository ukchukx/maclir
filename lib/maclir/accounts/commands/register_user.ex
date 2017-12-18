defmodule MacLir.Accounts.Commands.RegisterUser do
  defstruct [
    user_uuid: "",
    username: nil,
    email: nil,
    phone: "",
    latitude: 500,
    longitude: 500,
    password: "",
    hashed_password: "",
    role: "user"
  ]

  use ExConstructor
  use Vex.Struct

  alias MacLir.Accounts.Commands.RegisterUser
  alias MacLir.Auth

  validates :user_uuid, uuid: true
  validates :username, 
    format: [with: ~r/^[a-z_0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true, 
    unique_username: true

  validates :email,
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    unique_email: true
  validates :hashed_password, presence: [message: "can't be empty"], string: true
  validates :latitude, presence: [message: "can't be empty"], latitude: true
  validates :longitude, presence: [message: "can't be empty"], longitude: true
  validates :phone, presence: [message: "can't be empty"], phone: true, unique_phone: true
  validates :role, presence: [message: "can't be empty"], role: true

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%RegisterUser{} = register_user, uuid) do
    %RegisterUser{register_user | user_uuid: uuid}
  end

  @doc """
  Convert username to lowercase characters
  """
  def downcase_username(%RegisterUser{username: username} = register_user) do
    case username do
      nil -> register_user
      _ -> %RegisterUser{register_user | username: String.downcase(username)}
        
    end
  end

  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%RegisterUser{email: email} = register_user) do
    case email do
      nil -> register_user
      email -> %RegisterUser{register_user | email: String.downcase(email)}
    end
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%RegisterUser{password: password} = register_user) do
    %RegisterUser{register_user |
      password: nil,
      hashed_password: Auth.hash_password(password),
    }
  end
end

defimpl MacLir.Support.Middleware.Uniqueness.UniqueFields, for: MacLir.Accounts.Commands.RegisterUser do
  def unique(_command), do: [
    {:phone, "has already been taken"},
    {:username, "has already been taken"},
    {:email, "has already been taken"},
  ]
end