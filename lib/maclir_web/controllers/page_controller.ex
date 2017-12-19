defmodule MacLirWeb.PageController do
  use MacLirWeb, :controller

  alias MacLir.Accounts.Projections.User
  alias MacLir.Accounts

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

  def post_profile(conn, %{"profile" => params}) do
    params = Map.drop(params, ["role"])
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <- Accounts.update_user(user, params) do
      IO.inspect user, label: "user"
      conn
      |> Guardian.Plug.sign_in(user, :access)
      |> put_flash(:info, "Profile updated")
      |> render("profile.html")
    else
      {:error, :validation_failure, errors} ->
        IO.inspect errors, label: "page"
        conn
        |> put_flash(:error, "Could not update profile")
        |> redirect(to: page_path(conn, :profile))
    end
  end
end
