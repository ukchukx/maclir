defmodule MacLir.Router do
  use Commanded.Commands.Router

  alias MacLir.Accounts.Aggregates.{Friend,User}
  alias MacLir.Accounts.Commands.{CreateFriend,RegisterUser,UpdateUser}
  alias MacLir.Support.Middleware.{Uniqueness,Validate}

  middleware Validate
  middleware Uniqueness

  dispatch [RegisterUser, UpdateUser], to: User, identity: :user_uuid
  dispatch [CreateFriend], to: Friend, identity: :friend_uuid
end