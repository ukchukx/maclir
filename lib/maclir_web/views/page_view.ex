defmodule MacLirWeb.PageView do
  use MacLirWeb, :view

  alias MacLirWeb.LayoutView

  def friends(_conn) do
  	map = %{
  		image: "https://mdbootstrap.com/img/Photos/Avatars/avatar-13.jpg",
  		username: "johndoe"
  	}

  	[1, 2, 3, 4, 5]
  	|> Enum.map(fn _ -> map end)
  end

  def sent_friend_requests(_conn) do
    map = %{
      user: %{username: "janedoe", phone: "+234805xxxyyyy"}
    }

    [1, 2, 3]
    |> Enum.map(fn _ -> map end)
  end

  def received_friend_requests(_conn) do
  	map = %{
  		user: %{username: "johndoe", phone: "+234802xxxyyyy"}
  	}

  	[1, 2, 3]
  	|> Enum.map(fn _ -> map end)
  end

  def current_user(conn) do
    case LayoutView.current_user(conn) do
      nil -> %{username: "", phone: ""}
      user -> user        
    end
  end
end
