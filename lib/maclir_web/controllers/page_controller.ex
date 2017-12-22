defmodule MacLirWeb.PageController do
  use MacLirWeb, :controller

  alias MacLir.Accounts.Projections.{Friend,User}
  alias MacLir.Accounts

  def home(conn, _params) do
    render conn, "home.html"
  end

  def friends(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "friends.html", user: user
  end

  def friend_requests(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "friend_requests.html", user: user
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

  def post_friend_request(conn, %{"friend" => %{"phone" => phone}}) do
    %User{uuid: user_uuid} = user = Guardian.Plug.current_resource(conn)
    from_friend = Accounts.friend_by_user(user_uuid)

    case Accounts.user_by_phone(phone) do
      nil -> 
        conn
        |> put_flash(:error, "No such user")
        |> render("friends.html", user: user)

      %User{uuid: uuid} ->
        to_friend = Accounts.friend_by_user(uuid)

        with %Friend{} <- Accounts.add_friend(from_friend, to_friend) do
          conn
          |> put_flash(:info, "Request sent")
          |> render("friends.html", user: user)
        else
          reply ->
            IO.inspect reply, label: "post_profile"
            conn
            |> put_flash(:error, "Could not send request")
            |> render("friends.html", user: user)
        end
    end
  end

  end
end
