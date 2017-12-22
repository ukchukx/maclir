defmodule MacLir.Accounts.Projections.Friend do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}


  schema "accounts_friends" do
    field :user_uuid, :binary_id
    field :username, :string
    field :friends, {:array, :binary_id}, default: []
    field :received_requests, {:array, :binary_id}, default: []
    field :sent_requests, {:array, :binary_id}, default: [], virtual: true

    timestamps()
  end
end
