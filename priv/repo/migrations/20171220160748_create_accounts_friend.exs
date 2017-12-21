defmodule MacLir.Repo.Migrations.CreateAccountsFriends do
  use Ecto.Migration

  def change do
		create table(:accounts_friends, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :user_uuid, :uuid
      add :username, :string
      add :friends, {:array, :binary_id}
      add :received_requests, {:array, :binary_id}

      timestamps()
    end
    create unique_index(:accounts_friends, [:user_uuid])
  end
end
