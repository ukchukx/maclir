defmodule MacLir.Accounts.Projectors.User do
  use Commanded.Projections.Ecto, 
    name: "Accounts.Projectors.User",
    consistency: :strong

  alias MacLir.Accounts.Events.{
    UserEmailChanged,
    UsernameChanged,
    UserPhoneChanged,
    LocationChanged,
    RoleChanged,
    UserPasswordChanged,
    UserRegistered,
  }
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

  project %UsernameChanged{user_uuid: user_uuid, username: username} do
    update_user(multi, user_uuid, username: username)
  end

  project %UserEmailChanged{user_uuid: user_uuid, email: email} do
    update_user(multi, user_uuid, email: email)
  end

  project %UserPasswordChanged{user_uuid: user_uuid, hashed_password: hashed_password} do
    update_user(multi, user_uuid, hashed_password: hashed_password)
  end

  project %UserPhoneChanged{user_uuid: user_uuid, phone: phone} do
    update_user(multi, user_uuid, phone: phone)
  end

  project %LocationChanged{user_uuid: user_uuid, latitude: latitude, longitude: longitude} do
    update_user(multi, user_uuid, latitude: latitude, longitude: longitude)
  end

  project %RoleChanged{user_uuid: user_uuid, role: role} do
    update_user(multi, user_uuid, role: role)
  end

  defp update_user(multi, user_uuid, changes) do
    Ecto.Multi.update_all(multi, :user, user_query(user_uuid), set: changes)
  end

  defp user_query(user_uuid), do: from(u in User, where: u.uuid == ^user_uuid)
end