defmodule MacLir.Accounts.FriendTest do
  use MacLir.DataCase

  import Commanded.Assertions.EventAssertions

  alias Commanded.Aggregates.{Aggregate,ExecutionContext}
  alias MacLir.Accounts
  alias MacLir.Accounts.Aggregates.Friend, as: FriendAggregate
  alias MacLir.Accounts.Projections.{Friend,User}
  alias MacLir.Accounts.Commands.{CreateFriend}
  alias MacLir.Accounts.Events.{FriendCreated,FriendUpdated}

  alias MacLir.Helpers.ProcessHelper


  describe "a friend" do
    @tag :unit
    test "should be created when a user is registered" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))

      assert_receive_event FriendCreated, fn event ->
        assert event.friend_uuid == user.uuid
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
    test "should emit only 1 FriendCreated event" do
      uuid = UUID.uuid4()

      {:ok, ^uuid} = Commanded.Aggregates.Supervisor.open_aggregate(FriendAggregate, uuid)
      command = %CreateFriend{user_uuid: uuid, friend_uuid: uuid, username: "testuser"}
      context = %ExecutionContext{command: command, handler: FriendAggregate, function: :execute}
      
      {:ok, 1, events} = Aggregate.execute(FriendAggregate, uuid, context)
      assert events == [%FriendCreated{friend_uuid: uuid, user_uuid: uuid, username: "testuser"}]
      
      ProcessHelper.shutdown_aggregate(FriendAggregate, uuid)
      # reload aggregate to fetch persisted events from event store and rebuild state by applying saved events
      {:ok, ^uuid} = Commanded.Aggregates.Supervisor.open_aggregate(FriendAggregate, uuid)
      
      assert Aggregate.aggregate_version(FriendAggregate, uuid) == 1
      assert Aggregate.aggregate_state(FriendAggregate, uuid) == %FriendAggregate{uuid: uuid, user_uuid: uuid, username: "testuser"}
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