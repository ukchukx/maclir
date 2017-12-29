defmodule MacLir.Accounts.Workflows.UpdateFriendFromUser do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.UpdateFriendFromUser",
    consistency: :strong

  alias MacLir.Accounts.Events.UsernameChanged
  alias MacLir.Accounts.Commands.UpdateFriend
  alias MacLir.Router

  import MacLir.Support.Time, only: [recent?: 1, naive_to_datetime: 1]

  def handle(%UsernameChanged{user_uuid: uuid, username: username}, 
    %{causation_id: ca, correlation_id: co, created_at: created_at}) do
    created_at
    |> naive_to_datetime
    |> recent?
    |> case do
      false -> :ok
      true ->
        command = UpdateFriend.new(friend_uuid: uuid, username: username)
        opts = [causation_id: ca, correlation_id: co, consistency: :strong]
        
        with :ok <- Router.dispatch(command, opts) do
          :ok
        else
          reply -> reply
        end
    end 

  end
end

