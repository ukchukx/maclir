defmodule MacLirWeb.SessionController do
  use MacLirWeb, :controller

  def get_register(conn, _params) do
  	conn = assign(conn, :show_header, false)
    render conn, "register.html"
  end

  def register(conn, _params) do
    render conn, "register.html"
  end

  def get_login(conn, _params) do
  	conn = assign(conn, :show_header, false)
    render conn, "login.html"
  end

  def login(conn, _params) do
    render conn, "login.html"
  end

end