defmodule MacLirWeb.Plug.SocketToken do
  import Plug.Conn

  alias MacLir.Accounts.Projections.User

  def init(opts), do: opts

  def call(conn, _opts) do
  	case Guardian.Plug.current_resource(conn) do
  	  nil -> conn
  	  %User{uuid: uuid} -> 
  	  	token = Phoenix.Token.sign(conn, "socket_token", uuid)
  	  	conn
  	  	|> assign(:socket_token, token)  	    
  	  	|> assign(:socket_uuid, uuid)	    
  	end
  end
end