defmodule MacLir.FriendsTest do
  use MacLir.DataCase

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.Friend

	describe "add friend" do
		setup [
			:create_friends
		]

		@tag :integration
		test "should succeed if both parties are not friends", %{bob: b, alice: a} do
			Accounts.add_friend(a, b)

			%Friend{received_requests: reqs} = reload(b)
			assert 1 == Enum.count(reqs)
			assert Enum.member?(reqs, a.uuid)
		end

		@tag :integration
		test "should do nothing if both parties are friends", %{bob: b, alice: a} do
			b = make_friends(b, a)

			Accounts.add_friend(a, b)
			%Friend{received_requests: reqs} = reload(b)
			assert 0 == Enum.count(reqs)
		end

		@tag :integration
		test "should do nothing if recipient has a pending request from sender", 
			%{bob: b, alice: a} do
			Accounts.add_friend(a, b)

			%Friend{received_requests: reqs} = reload(b)
			assert 1 == Enum.count(reqs)
			assert Enum.member?(reqs, a.uuid)
		end
	end 

	describe "cancel friend request" do
		setup [
			:create_friends,
			:send_friend_request
		]

		@tag :integration
		test "should do nothing if recipient is friends with sender", 
			%{bob: b, alice: a} do
			make_friends(a, b)

			%Friend{received_requests: a_reqs, friends: a_friends} = Accounts.cancel_friend_request(a, b)			
			%Friend{received_requests: b_reqs, friends: b_friends} = reload(b)
			
			assert 1 == Enum.count(a_friends)
			assert Enum.member?(a_friends, b.uuid)
			assert 1 == Enum.count(b_friends)
			assert Enum.member?(b_friends, a.uuid)

			refute Enum.member?(b_reqs, a.uuid)
			assert 0 == Enum.count(b_reqs)
			refute Enum.member?(a_reqs, b.uuid)
			assert 0 == Enum.count(a_reqs)
		end

		@tag :integration
		test "should succeed if recipient had a pending request from sender", 
			%{bob: b, alice: a} do
			%Friend{received_requests: reqs} = reload(b)
			assert 1 == Enum.count(reqs)
			assert Enum.member?(reqs, a.uuid)

			Accounts.cancel_friend_request(a, b)			
			%Friend{received_requests: reqs} = reload(b)
			assert 0 == Enum.count(reqs)
		end
		
	end

	describe "accept friend request" do
		setup [
			:create_friends
		]

		@tag :integration
		test "should do nothing if there's no pending request from recipient", 
			%{bob: b, alice: a} do

			%Friend{received_requests: b_reqs, friends: b_friends} = Accounts.accept_friend_request(b, a)			
			%Friend{received_requests: a_reqs, friends: a_friends} = reload(a)
			
			assert 0 == Enum.count(a_friends)
			assert 0 == Enum.count(b_friends)
			refute Enum.member?(b_reqs, a.uuid)
			assert 0 == Enum.count(b_reqs)
			refute Enum.member?(a_reqs, b.uuid)
			assert 0 == Enum.count(a_reqs)
		end

		@tag :integration
		test "should succeed if there's a pending request from recipient", 
			%{bob: b, alice: a} = context do
			send_friend_request(context)

			%Friend{received_requests: b_reqs, friends: b_friends} = Accounts.accept_friend_request(b, a)			
			%Friend{received_requests: a_reqs, friends: a_friends} = reload(a)
			
			assert 1 == Enum.count(a_friends)
			assert 1 == Enum.count(b_friends)
			assert Enum.member?(b_friends, a.uuid)
			assert Enum.member?(a_friends, b.uuid)
			assert 0 == Enum.count(b_reqs)
			assert 0 == Enum.count(a_reqs)
		end
	end

	describe "reject friend request" do
		setup [
			:create_friends
		]

		@tag :integration
		test "should do nothing if there's no pending request from recipient", 
			%{bob: b, alice: a} do

			%Friend{received_requests: b_reqs, friends: b_friends} = Accounts.reject_friend_request(b, a)			
			%Friend{received_requests: a_reqs, friends: a_friends} = reload(a)
			
			assert 0 == Enum.count(a_friends)
			assert 0 == Enum.count(b_friends)
			assert 0 == Enum.count(b_reqs)
			assert 0 == Enum.count(a_reqs)
		end

		@tag :integration
		test "should succeed if there's a pending request from recipient", 
			context do
			[alice: a, bob: b] = send_friend_request(context)
			assert 1 == Enum.count(b.received_requests)
			assert 0 == Enum.count(a.received_requests)
			assert 0 == Enum.count(a.friends)
			assert 0 == Enum.count(b.friends)

			%Friend{received_requests: b_reqs, friends: b_friends} = Accounts.reject_friend_request(b, a)			
			%Friend{received_requests: a_reqs, friends: a_friends} = reload(a)
			
			assert 0 == Enum.count(a_friends)
			assert 0 == Enum.count(b_friends)
			assert 0 == Enum.count(a_reqs)
			assert 0 == Enum.count(b_reqs)
		end
	end

	describe "remove friend" do
		setup [
			:create_friends,
			:send_friend_request
		]

		@tag :integration
		test "should do nothing if recipient is not friends with sender", 
			%{bob: b, alice: a} do
			b = reload(b)
			refute Enum.member?(b.friends, a.uuid)

			a = Accounts.remove_friend(a, b)
			b = reload(b)

			assert 0 == Enum.count(a.friends)
			assert 0 == Enum.count(b.friends)
		end

		@tag :integration
		test "should succeed if recipient is friends with sender", 
			%{alice: a, bob: b} do
			assert Enum.member?(b.received_requests, a.uuid)

			b = Accounts.accept_friend_request(b, a)
			a = reload(a)

			assert 1 == Enum.count(b.friends)
			assert Enum.member?(b.friends, a.uuid)
			assert 1 == Enum.count(a.friends)
			assert Enum.member?(a.friends, b.uuid)

			b = Accounts.remove_friend(b, a)
			a =  reload(a)

			assert 0 == Enum.count(a.received_requests)
			assert 0 == Enum.count(a.friends)
			assert 0 == Enum.count(b.friends)
			assert 0 == Enum.count(b.received_requests)
		end
	end

	defp reload(%Friend{uuid: uuid}), do: Accounts.friend_by_uuid(uuid)
end