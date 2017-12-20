defmodule MacLir.Accounts.FriendTest do
  use MacLir.DataCase

  import Commanded.Assertions.EventAssertions

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User
  alias MacLir.Accounts.Events.FriendCreated

  describe "a friend" do
    @tag :unit
    test "should be created when a user is registered" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))

      assert_receive_event FriendCreated, fn event ->
        refute event.friend_uuid == ""
        assert event.user_uuid == user.uuid
        assert event.username == user.username
      end
    end
  end
end