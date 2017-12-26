defmodule MacLir.Accounts.Workflows.UpdateFriendFromUser do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.UpdateFriendFromUser",
    consistency: :strong

  alias MacLir.Accounts.Events.UsernameChanged
  alias MacLir.Accounts.Commands.UpdateFriend
  alias MacLir.Router

  def handle(%UsernameChanged{user_uuid: uuid, username: username}, %{causation_id: cause, correlation_id: corr}) do
    command = UpdateFriend.new(friend_uuid: uuid, username: username)
    with :ok <- Router.dispatch(command, causation_id: cause, correlation_id: corr, consistency: :strong) do
      :ok
    else
      reply -> reply
    end
  end
end

