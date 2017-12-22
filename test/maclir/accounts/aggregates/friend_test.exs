defmodule MacLir.Accounts.FriendTest do
  use MacLir.DataCase

  import Commanded.Assertions.EventAssertions

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.{Friend,User}
  alias MacLir.Accounts.Events.{FriendCreated,FriendUpdated}

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

    @tag :unit
    test "should be updated when a user is updated" do
      assert {:ok, %User{uuid: uuid} = user} = Accounts.register_user(build(:user))
      {:ok, user} = Accounts.update_user(user, %{username: "updatedusername"})
      %Friend{uuid: friend_uuid} = Accounts.friend_by_user(uuid)

      assert_receive_event FriendUpdated, fn event ->
        assert event.friend_uuid == friend_uuid
        assert event.username == user.username
      end
    end

    @tag :unit
    test "should have sent_requests populated after sending a friend request", context do
      [alice: a, bob: b] = create_friends(context)
      a = Accounts.add_friend(a, b) |> Accounts.load_sent_requests

      assert 1 == Enum.count(a.sent_requests)
      assert Enum.member?(a.sent_requests, b.uuid)
    end
  end
end