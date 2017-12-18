defmodule MacLir.Accounts.Projectors.User do
  use Commanded.Projections.Ecto, 
    name: "Accounts.Projectors.User",
    consistency: :strong

  alias MacLir.Accounts.Events.UserRegistered
  alias MacLir.Accounts.Projections.User

  project %UserRegistered{} = registered do
    Ecto.Multi.insert(multi, :user, %User{
      uuid: registered.user_uuid,
      username: registered.username,
      role: registered.role,
      email: registered.email,
      phone: registered.phone,
      latitude: registered.latitude,
      longitude: registered.longitude,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil,
    })
  end
end