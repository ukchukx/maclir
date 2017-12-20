defmodule MacLir.Accounts.Workflows.CreateFriendFromUser do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.CreateFriendFromUser",
    consistency: :strong

  alias MacLir.Accounts.Events.UserRegistered
  alias MacLir.Accounts

  def handle(%UserRegistered{user_uuid: user_uuid, username: username}, _metadata) do
    with {:ok, _friend} <- Accounts.create_friend(%{user_uuid: user_uuid, username: username}) do
      :ok
    else
      reply -> reply
    end
  end
end