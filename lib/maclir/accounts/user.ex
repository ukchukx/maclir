defmodule MacLir.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MacLir.Accounts.User


  schema "accounts_users" do
    field :bio, :string
    field :email, :string
    field :hashed_password, :string
    field :image, :string
    field :lat, :float
    field :long, :float
    field :phone, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hashed_password, :bio, :image, :lat, :long, :phone])
    |> validate_required([:username, :email, :hashed_password, :bio, :image, :lat, :long, :phone])
  end
end
