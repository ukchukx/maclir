defmodule MacLirWeb.PageController do
  use MacLirWeb, :controller

  def home(conn, _params) do
    render conn, "home.html"
  end

  def friends(conn, _params) do
    render conn, "friends.html"
  end

  def friend_requests(conn, _params) do
    render conn, "friend_requests.html"
  end

  def profile(conn, _params) do
    render conn, "profile.html"
  end
end
