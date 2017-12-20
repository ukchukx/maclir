defmodule MacLir.Fixture do
  import MacLir.Factory
  
  alias MacLir.Accounts

  def fixture(resource, attrs \\ [])

  def fixture(:friend, attrs) do
    build(:friend, attrs) |> Accounts.create_friend()
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end

  def register_user(_context) do
    {:ok, user} = fixture(:user)

    [user: user]
  end

  def create_friend(_context) do
    {:ok, friend} = fixture(:friend, user_uuid: UUID.uuid4())

    [friend: friend]
  end
end