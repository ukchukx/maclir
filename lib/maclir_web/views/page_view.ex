defmodule MacLirWeb.PageView do
  use MacLirWeb, :view

  alias MacLirWeb.LayoutView
  alias MacLir.Accounts

  def friends(%{assigns: %{user: %{uuid: uuid}}} = _conn) do
  	map = %{
  		image: "https://mdbootstrap.com/img/Photos/Avatars/avatar-13.jpg",
  	}

  	uuid
    |> Accounts.user_friends
  	|> Enum.map(&(Map.merge(&1, map)))
  end
  def friends(_), do: []

  def sent_friend_requests(%{assigns: %{user: %{uuid: uuid}}} = _conn) do
    uuid
    |> Accounts.user_sent_requests
    |> Enum.map(&(%{user: Accounts.user_by_uuid(&1.user_uuid), friend: &1}))
  end
  def sent_friend_requests(_), do: []

  def received_friend_requests(%{assigns: %{user: %{uuid: uuid}}} = _conn) do
  	uuid
    |> Accounts.user_received_requests
    |> Enum.map(&(%{user: Accounts.user_by_uuid(&1.user_uuid)}))
  end
  def received_friend_requests(_), do: []

  def current_user(conn) do
    case LayoutView.current_user(conn) do
      nil -> %{username: "", phone: ""}
      user -> user        
    end
  end
end
