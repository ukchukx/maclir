defmodule MacLir.Accounts.Aggregates.UserTest do
  use MacLir.AggregateCase, aggregate: MacLir.Accounts.Aggregates.User

  alias MacLir.Accounts.Events.UserRegistered

  import MacLir.Factory

  describe "register user" do
    @tag :unit
    test "should succeed when valid" do
      user_uuid = UUID.uuid4()
      params = build(:user)

      assert_events build(:register_user, user_uuid: user_uuid), [
        %UserRegistered{
          user_uuid: user_uuid,
          email: params.email,
          role: params.role,
          phone: params.phone,
          latitude: params.latitude,
          longitude: params.longitude,
          username: params.username,
          hashed_password: params.hashed_password,
        }
      ]
    end
  end
end