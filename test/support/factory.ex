defmodule MacLir.Factory do
  use ExMachina

  alias MacLir.Accounts.Commands.RegisterUser

  def user_factory do
    %{
      email: "jake@jake.jake",
      phone: "+2348121234567",
      latitude: 9.1490051,
      longitude: 7.3233646,
      role: "user",
      username: "jake",
      password: "jakejake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg",
    }
  end

  def author_factory do
    %{
      user_uuid: UUID.uuid4(),
      username: "jake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg",
    }
  end

  def register_user_factory do
    struct(RegisterUser, build(:user))
  end
end