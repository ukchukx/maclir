defmodule MacLir.Accounts.Workflows.UpdateFriendFromUser do
  use Commanded.Event.Handler,
    name: "Accounts.Workflows.UpdateFriendFromUser",
    consistency: :strong

  alias MacLir.Accounts.Projections.Friend
  alias MacLir.Accounts.Events.UsernameChanged
  alias MacLir.Accounts.Commands.UpdateFriend
  alias MacLir.{Accounts,Router}

  def handle(%UsernameChanged{user_uuid: user_uuid, username: username}, %{causation_id: cause, correlation_id: corr}) do
    %Friend{uuid: uuid} = Accounts.friend_by_user(user_uuid)
    command = UpdateFriend.new(friend_uuid: uuid, username: username)
    with :ok <- Router.dispatch(command, causation_id: cause, correlation_id: corr, consistency: :strong) do
      :ok
    else
      reply -> reply
    end
  end
end

