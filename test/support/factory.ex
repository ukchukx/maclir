defmodule Conduit.Factory do
  use ExMachina

  def user_factory do
    %{
      email: "jake@jake.jake",
      phone: "+2348121234567",
      lat: 9.1490051,
      long: 7.3233646,
      username: "jake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg",
    }
  end
end