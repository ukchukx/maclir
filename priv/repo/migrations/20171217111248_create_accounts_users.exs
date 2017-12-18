defmodule MacLir.Repo.Migrations.CreateAccountsUsers do
  use Ecto.Migration

  def change do
    create table(:accounts_users, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :username, :string
      add :role, :string
      add :email, :string
      add :hashed_password, :string
      add :bio, :string
      add :image, :string
      add :latitude, :float
      add :longitude, :float
      add :phone, :string

      timestamps()
    end
    create unique_index(:accounts_users, [:username])
    create unique_index(:accounts_users, [:email])
    create unique_index(:accounts_users, [:phone])

  end
end
