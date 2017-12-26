defmodule MacLir.Router do
  use Commanded.Commands.Router

  alias MacLir.Accounts.Aggregates.{Friend,User}
  alias MacLir.Accounts.Commands.{
  	AcceptFriend,
    AddFriend,
    CancelFriend,
    CreateFriend,
    RejectFriend,
    RemoveFriend,
    CreateFriend,
    RegisterUser,
    UpdateFriend,
  	UpdateUser
  }
  alias MacLir.Support.Middleware.{Uniqueness,Validate}

  middleware Validate
  middleware Uniqueness

  identify User, by: :user_uuid, prefix: "user-"
  identify Friend, by: :friend_uuid, prefix: "friend-"

  dispatch [RegisterUser, UpdateUser], to: User
  dispatch [
  	AcceptFriend,
    AddFriend,
    CancelFriend,
    CreateFriend,
    RejectFriend,
    RemoveFriend,
    UpdateFriend
  ], to: Friend
end