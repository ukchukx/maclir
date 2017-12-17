defmodule MacLirWeb.PageController do
  use MacLirWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def friends(conn, _params) do
    render conn, "index.html"
  end

  def notifs(conn, _params) do
    render conn, "index.html"
  end
end
