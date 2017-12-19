defmodule MacLir.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :username,
    :role,
    :email,
    :phone,
    :latitude,
    :longitude,
    :hashed_password,
  ]

  alias MacLir.Accounts.Aggregates.User
  alias MacLir.Accounts.Commands.{RegisterUser,UpdateUser}
  alias MacLir.Accounts.Events.{
    UserEmailChanged,
    UsernameChanged,
    UserPhoneChanged,
    LocationChanged,
    RoleChanged,
    UserPasswordChanged,
    UserRegistered,
  }

  @doc """
  Register a new user
  """
  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      user_uuid: register.user_uuid,
      username: register.username,
      role: register.role,
      email: register.email,
      phone: register.phone,
      latitude: register.latitude,
      longitude: register.longitude,
      hashed_password: register.hashed_password,
    }
  end

  @doc """
  Update a user's username, email, and password
  """
  def execute(%User{} = user, %UpdateUser{} = update) do
    Enum.reduce([&username_changed/2, 
      &email_changed/2, 
      &location_changed/2, 
      &phone_changed/2,
      &role_changed/2,
      &password_changed/2], 
      [], fn (change, events) ->
      case change.(user, update) do
        nil -> events
        event -> [event | events]
      end
    end)
  end

  # state mutators

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{user |
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      phone: registered.phone,
      latitude: registered.latitude,
      longitude: registered.longitude,
      hashed_password: registered.hashed_password,
    }
  end

  def apply(%User{} = user, %UsernameChanged{username: username}) do
    %User{user | username: username}
  end

  def apply(%User{} = user, %UserEmailChanged{email: email}) do
    %User{user | email: email}
  end

  def apply(%User{} = user, %UserPhoneChanged{phone: phone}) do
    %User{user | phone: phone}
  end

  def apply(%User{} = user, %LocationChanged{latitude: latitude, longitude: longitude}) do
    %User{user | latitude: latitude, longitude: longitude}
  end

  def apply(%User{} = user, %UserPasswordChanged{hashed_password: hashed_password}) do
    %User{user | hashed_password: hashed_password}
  end

  def apply(%User{} = user, %RoleChanged{role: role}) do
    %User{user | role: role}
  end

  # private helpers

  defp username_changed(%User{}, %UpdateUser{username: ""}), do: nil
  defp username_changed(%User{}, %UpdateUser{username: nil}), do: nil
  defp username_changed(%User{username: username}, %UpdateUser{username: username}), do: nil
  defp username_changed(%User{uuid: user_uuid}, %UpdateUser{username: username}) do
    %UsernameChanged{
      user_uuid: user_uuid,
      username: username,
    }
  end

  defp email_changed(%User{}, %UpdateUser{email: ""}), do: nil
  defp email_changed(%User{}, %UpdateUser{email: nil}), do: nil
  defp email_changed(%User{email: email}, %UpdateUser{email: email}), do: nil
  defp email_changed(%User{uuid: user_uuid}, %UpdateUser{email: email}) do
    %UserEmailChanged{
      user_uuid: user_uuid,
      email: email,
    }
  end

  defp phone_changed(%User{}, %UpdateUser{phone: ""}), do: nil
  defp phone_changed(%User{}, %UpdateUser{phone: nil}), do: nil
  defp phone_changed(%User{phone: phone}, %UpdateUser{phone: phone}), do: nil
  defp phone_changed(%User{uuid: user_uuid}, %UpdateUser{phone: phone}) do
    %UserPhoneChanged{
      user_uuid: user_uuid,
      phone: phone,
    }
  end

  defp location_changed(%User{}, %UpdateUser{latitude: l, longitude: _}) when l == nil or l == "" do
    nil
  end
  defp location_changed(%User{}, %UpdateUser{latitude: _, longitude: l}) when l == nil or l == "" do
    nil
  end
  defp location_changed(%User{latitude: latitude, longitude: longitude}, %UpdateUser{latitude: latitude, longitude: longitude}), do: nil
  defp location_changed(%User{uuid: _user_uuid}, %UpdateUser{latitude: nil, longitude: nil}), do: nil
  defp location_changed(%User{uuid: user_uuid}, %UpdateUser{latitude: latitude, longitude: longitude}) do
    %LocationChanged{
      user_uuid: user_uuid,
      latitude: latitude,
      longitude: longitude,
    }
  end

  defp role_changed(%User{}, %UpdateUser{role: ""}), do: nil
  defp role_changed(%User{role: role}, %UpdateUser{role: role}), do: nil
  defp role_changed(%User{uuid: user_uuid}, %UpdateUser{role: role = "user"}) do
    %RoleChanged{
      user_uuid: user_uuid,
      role: role,
    }
  end
  defp role_changed(%User{uuid: user_uuid}, %UpdateUser{role: role = "admin"}) do
    %RoleChanged{
      user_uuid: user_uuid,
      role: role,
    }
  end
  defp role_changed(%User{}, %UpdateUser{role: _}), do: nil

  defp password_changed(%User{}, %UpdateUser{hashed_password: ""}), do: nil
  defp password_changed(%User{}, %UpdateUser{hashed_password: nil}), do: nil
  defp password_changed(%User{hashed_password: hashed_password}, %UpdateUser{hashed_password: hashed_password}), do: nil
  defp password_changed(%User{uuid: user_uuid}, %UpdateUser{hashed_password: hashed_password}) do
    %UserPasswordChanged{
      user_uuid: user_uuid,
      hashed_password: hashed_password,
    }
  end
end