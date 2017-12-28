defmodule MacLir.Accounts.Workflows.CreateFriendFromUser do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.CreateFriendFromUser",
    consistency: :strong

  alias MacLir.Accounts.Events.UserRegistered
  alias MacLir.Accounts

  import MacLir.Support.Time, only: [recent?: 1, naive_to_datetime: 1]

  def handle(%UserRegistered{user_uuid: user_uuid, username: username}, %{created_at: created_at}) do
    created_at
    |> naive_to_datetime
    |> recent?
    |> case do
      false -> :ok
      true ->
        with {:ok, _friend} <- Accounts.create_friend(%{user_uuid: user_uuid, username: username}) do
          :ok
        else
          reply -> reply
        end
    end
  end
end

