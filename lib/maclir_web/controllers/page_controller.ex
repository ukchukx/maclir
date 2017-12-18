defmodule MacLirWeb.PageController do
  use MacLirWeb, :controller

  def home(conn, _params) do
    render conn, "home.html"
  end

  def friends(conn, _params) do
    render conn, "home.html"
  end

  def notifs(conn, _params) do
    render conn, "home.html"
  end
end
