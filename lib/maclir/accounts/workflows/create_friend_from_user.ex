defmodule MacLir.Accounts.Workflows.CreateFriendFromUser do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.CreateFriendFromUser",
    consistency: :strong

  alias MacLir.Accounts.Events.UserRegistered
  alias MacLir.Accounts

  import MacLir.Support.Time, only: [recent?: 1, naive_to_datetime: 1]

  def handle(%UserRegistered{user_uuid: user_uuid, username: username}, 
    %{causation_id: ca, correlation_id: co, created_at: created_at}) do
    created_at
    |> naive_to_datetime
    |> recent?
    |> case do
      false -> :ok
      true ->
        opts = [causation_id: ca, correlation_id: co]
        attrs = %{user_uuid: user_uuid, username: username}
        
        with {:ok, _friend} <- Accounts.create_friend(attrs, opts) do
          :ok
        else
          reply -> reply
        end
    end
  end
end

