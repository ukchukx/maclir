defmodule MacLirWeb.PageView do
  use MacLirWeb, :view

  def friends(_conn) do
  	map = %{
  		image: "https://mdbootstrap.com/img/Photos/Avatars/avatar-13.jpg",
  		username: "johndoe"
  	}

  	[1, 2, 3, 4, 5]
  	|> Enum.map(fn _ -> map end)
  end

  def friend_requests(_conn) do
  	map = %{
  		user: %{username: "johndoe", phone: "+234802xxxyyyy"}
  	}

  	[1, 2, 3, 4, 5]
  	|> Enum.map(fn _ -> map end)
  end
end
