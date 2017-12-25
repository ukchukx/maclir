defmodule MacLirWeb.PageController do
  use MacLirWeb, :controller

  alias MacLir.Accounts.Projections.{Friend,User}
  alias MacLir.Accounts

  def home(conn, _params) do
    render conn, "home.html"
  end

  def friends(conn = %{assigns: assigns}, _params) do
    render conn, "friends.html", user: assigns[:current_user]
  end

  def friend_requests(conn = %{assigns: assigns}, _params) do
    render conn, "friend_requests.html", user: assigns[:current_user]
  end

  def profile(conn, _params) do
    render conn, "profile.html"
  end

  def post_profile(conn = %{assigns: assigns}, %{"profile" => params}) do
    params = Map.drop(params, ["role"])
    user = assigns[:current_user]

    with {:ok, %User{} = user} <- Accounts.update_user(user, params) do
      conn
      |> Guardian.Plug.sign_in(user, :access)
      |> put_flash(:info, "Profile updated")
      |> redirect(to: page_path(conn, :profile))
    else
      {:error, :validation_failure, errors} ->
        IO.inspect errors, label: "page"
        conn
        |> put_flash(:error, "Could not update profile")
        |> redirect(to: page_path(conn, :profile))
    end
  end

  def post_friend_request(conn = %{assigns: assigns}, %{"friend" => %{"phone" => phone}}) do
    %User{uuid: user_uuid} = assigns[:current_user]
    from_friend = Accounts.friend_by_user(user_uuid)

    case Accounts.user_by_phone(phone) do
      nil -> 
        conn
        |> put_flash(:error, "No such user")
        |> redirect(to: page_path(conn, :friends))

      %User{uuid: uuid} ->
        to_friend = Accounts.friend_by_user(uuid)

        with %Friend{} <- Accounts.add_friend(from_friend, to_friend) do
          conn
          |> put_flash(:info, "Request sent")
          |> redirect(to: page_path(conn, :friends))
        else
          reply ->
            IO.inspect reply, label: "post_friend_request"
            conn
            |> put_flash(:error, "Could not send request")
            |> redirect(to: page_path(conn, :friends))
        end
    end
  end

  def post_cancel_friend_request(conn = %{assigns: assigns}, %{"cancel" => %{"uuid" => uuid}}) do
    %User{uuid: user_uuid} = assigns[:current_user]
    from_friend = Accounts.friend_by_user(user_uuid)
    to_friend = Accounts.friend_by_uuid(uuid)

    with %Friend{} <- Accounts.cancel_friend_request(from_friend, to_friend) do
      conn
      |> put_flash(:info, "Request cancelled")
      |> redirect(to: page_path(conn, :friend_requests))
    else
      reply ->
        IO.inspect reply, label: "cancel_friend_request"
        conn
        |> put_flash(:error, "Could not cancel request")
        |> redirect(to: page_path(conn, :friend_requests))
    end
  end

  def post_accept_friend_request(conn = %{assigns: assigns}, %{"accept" => %{"uuid" => uuid}}) do
    %User{uuid: user_uuid} = assigns[:current_user]
    from_friend = Accounts.friend_by_user(user_uuid)
    to_friend = Accounts.friend_by_uuid(uuid)

    with %Friend{} <- Accounts.accept_friend_request(from_friend, to_friend) do
      redirect conn, to: page_path(conn, :friend_requests)
    else
      reply ->
        IO.inspect reply, label: "accept_friend_request"
        redirect conn, to: page_path(conn, :friend_requests)
    end
  end

  def post_reject_friend_request(conn = %{assigns: assigns}, %{"reject" => %{"uuid" => uuid}}) do
    %User{uuid: user_uuid} = assigns[:current_user]
    from_friend = Accounts.friend_by_user(user_uuid)
    to_friend = Accounts.friend_by_uuid(uuid)

    with %Friend{} <- Accounts.reject_friend_request(from_friend, to_friend) do
      redirect conn, to: page_path(conn, :friend_requests)
    else
      reply ->
        IO.inspect reply, label: "reject_friend_request"
        redirect conn, to: page_path(conn, :friend_requests)
    end
  end

  def post_remove_friend(conn = %{assigns: assigns}, %{"remove" => %{"uuid" => uuid}}) do
    %User{uuid: user_uuid} = assigns[:current_user]
    from_friend = Accounts.friend_by_user(user_uuid)
    to_friend = Accounts.friend_by_uuid(uuid)

    with %Friend{} <- Accounts.remove_friend(from_friend, to_friend) do
      redirect conn, to: page_path(conn, :friends)
    else
      reply ->
        IO.inspect reply, label: "remove_friend"
        redirect conn, to: page_path(conn, :friends)
    end
  end
end
