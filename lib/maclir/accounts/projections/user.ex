defmodule MacLir.Accounts.Projections.User do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}


  schema "accounts_users" do
    field :bio, :string
    field :hashed_password, :string
    field :role, :string, default: "user"
    field :image, :string
    field :latitude, :float
    field :longitude, :float
    field :email, :string, unique: true
    field :phone, :string, unique: true
    field :username, :string, unique: true

    timestamps()
  end
end
