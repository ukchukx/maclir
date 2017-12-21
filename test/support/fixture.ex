defmodule MacLir.Fixture do
  import MacLir.Factory
  
  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.Friend

  def fixture(resource, attrs \\ [])

  def fixture(:friend, attrs) do
    {:ok, %{uuid: user_uuid}} = fixture(:user, attrs)
    Accounts.friend_by_user(user_uuid)
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end

  def register_user(_context) do
    {:ok, user} = fixture(:user)

    [user: user]
  end

  def create_friends(_context) do
    alice = fixture(:friend, username: "alice")
    bob = fixture(:friend, username: "bobby", email: "bob@bobby.bob", phone: "08056667777")

    [alice: alice, bob: bob]
  end

  def send_friend_request(%{alice: a, bob: b}) do
    a = Accounts.add_friend(a, b)
    [alice: a, bob: Accounts.friend_by_uuid(b.uuid)]
  end

  def accept_friend_request(%{alice: a, bob: b}) do
    b = Accounts.accept_friend_request(b, a)
    [bob: b, alice: Accounts.friend_by_uuid(a.uuid)]
  end


  def make_friends(%Friend{} = sender, %Friend{} = recipient) do
    sender = Accounts.add_friend(sender, recipient)
    _recipient = Accounts.accept_friend_request(recipient, sender)
  end
end