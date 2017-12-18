defmodule MacLirWeb.API.UserView do
  use MacLirWeb, :view
  alias MacLirWeb.API.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user, jwt: jwt}) do
    %{data: user |> render_one(UserView, "user.json") |> Map.merge(%{token: jwt})}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.uuid,
      username: user.username,
      email: user.email,
      role: user.role,
      bio: user.bio,
      image: user.image,
      latitude: user.latitude,
      longitude: user.longitude,
      phone: user.phone}
  end
end
