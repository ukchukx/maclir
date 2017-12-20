defmodule MacLir.Accounts.Commands.RegisterUser do
  defstruct [
    user_uuid: "",
    username: "",
    email: "",
    phone: "",
    latitude: 500,
    longitude: 500,
    password: "",
    hashed_password: "",
    role: "user"
  ]

  use ExConstructor
  use Vex.Struct

  alias MacLir.Accounts.Validators.{UniqueEmail,UniqueUsername,UniquePhone}
  alias MacLir.Auth

  validates :user_uuid, uuid: true
  validates :username, 
    presence: [message: "can't be empty"],
    length: [min: 4], 
    format: [with: ~r/^[a-z_0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true, 
    by: &UniqueUsername.validate/2

  validates :email,
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2

  validates :phone, 
    presence: [message: "can't be empty"], 
    phone: true, 
    by: &UniquePhone.validate/2

  validates :hashed_password, presence: [message: "can't be empty"], string: true
  validates :latitude, presence: [message: "can't be empty"], latitude: true
  validates :longitude, presence: [message: "can't be empty"], longitude: true
  validates :role, presence: [message: "can't be empty"], role: true

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%__MODULE__{} = register_user, uuid) do
    %__MODULE__{register_user | user_uuid: uuid}
  end

  @doc """
  Convert username to lowercase characters
  """
  def downcase_username(%__MODULE__{username: username} = register_user) do
    case is_binary(username) do
      false -> register_user
      true -> %__MODULE__{register_user | username: String.downcase(username)}
        
    end
  end

  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%__MODULE__{email: email} = register_user) do
    case is_binary(email) do
      false -> register_user
      true -> %__MODULE__{register_user | email: String.downcase(email)}
    end
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%__MODULE__{password: password} = register_user) do
    %__MODULE__{register_user |
      password: nil,
      hashed_password: Auth.hash_password(password),
    }
  end
end

defimpl MacLir.Support.Middleware.Uniqueness.UniqueFields, for: MacLir.Accounts.Commands.RegisterUser do
  def unique(%MacLir.Accounts.Commands.RegisterUser{user_uuid: user_uuid}), do: [
    {:phone, "has already been taken", user_uuid},
    {:username, "has already been taken", user_uuid},
    {:email, "has already been taken", user_uuid},
  ]
end