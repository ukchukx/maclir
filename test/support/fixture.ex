defmodule MacLir.Fixture do
  import MacLir.Factory
  
  alias MacLir.Accounts

  def fixture(:user, attrs \\ []) do
    build(:user, attrs) |> Accounts.register_user()
  end
end