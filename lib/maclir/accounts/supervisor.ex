defmodule MacLir.Accounts.Supervisor do
  use Supervisor

  alias MacLir.Accounts
  
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init([
      Accounts.Projectors.User,
      Accounts.Projectors.Friend,
      Accounts.Workflows.CreateFriendFromUser,
      Accounts.Workflows.RelayFriendEvents
    ], strategy: :one_for_one)
  end
end