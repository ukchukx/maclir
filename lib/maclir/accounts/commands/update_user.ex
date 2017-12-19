defmodule MacLir.Accounts.Commands.UpdateUser do
  defstruct [
    user_uuid: "",
    username: "",
    email: nil,
    password: "",
    hashed_password: "",
    phone: "",
    latitude: nil,
    longitude: nil,
    role: "user"
  ]
  

  use ExConstructor
  use Vex.Struct

  alias MacLir.Accounts.Commands.UpdateUser
  alias MacLir.Accounts.Projections.User
  alias MacLir.Accounts.Validators.{UniqueEmail,UniqueUsername,UniquePhone}
  alias MacLir.Auth

  validates :user_uuid, uuid: true

  validates :username,
    length: [min: 4, allow_blank: true],
    format: [with: ~r/^[a-z_0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueUsername.validate/2

  validates :email,
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2

  validates :phone, 
    phone: [allow_blank: true], 
    by: &UniquePhone.validate/2

  validates :hashed_password, string: [allow_nil: true, allow_blank: true]
  validates :latitude, latitude: [allow_nil: true]
  validates :longitude, longitude: [allow_nil: true]
  validates :role, role: [allow_nil: true, allow_blank: true]

  @doc """
  Assign the user identity
  """
  def assign_user(%UpdateUser{} = update_user, %User{uuid: user_uuid}) do
    %UpdateUser{update_user | user_uuid: user_uuid}
  end

  @doc """
  Convert username to lowercase characters
  """
  def downcase_username(%UpdateUser{username: username} = update_user) do
    case is_binary(username) do
      false -> update_user
      true ->  %UpdateUser{update_user | username: String.downcase(username)}
    end
  end

  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%UpdateUser{email: email} = update_user) do
    case is_binary(email) do
      false -> update_user
      true ->  %UpdateUser{update_user | email: String.downcase(email)}
    end
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%UpdateUser{password: ""} = update_user), do: update_user
  def hash_password(%UpdateUser{password: nil} = update_user), do: update_user
  def hash_password(%UpdateUser{password: password} = update_user) do
    %UpdateUser{update_user |
      password: nil,
      hashed_password: Auth.hash_password(password),
    }
  end
end

defimpl MacLir.Support.Middleware.Uniqueness.UniqueFields, for: MacLir.Accounts.Commands.UpdateUser do
  def unique(%MacLir.Accounts.Commands.UpdateUser{user_uuid: user_uuid}), do: [
    {:phone, "has already been taken", user_uuid},
    {:username, "has already been taken", user_uuid},
    {:email, "has already been taken", user_uuid},
  ]
end