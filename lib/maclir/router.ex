defmodule MacLir.Router do
  use Commanded.Commands.Router

  alias MacLir.Accounts.Aggregates.User
  alias MacLir.Accounts.Commands.{RegisterUser,UpdateUser}
  alias MacLir.Support.Middleware.{Uniqueness,Validate}

  middleware Validate
  middleware Uniqueness

  dispatch [RegisterUser, UpdateUser], to: User, identity: :user_uuid
end