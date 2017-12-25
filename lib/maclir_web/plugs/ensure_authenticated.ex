defmodule MacLirWeb.Plug.EnsureAuthenticated do
	import Plug.Conn

  alias MacLir.Accounts.Projections.User

	def init(opts), do: opts

	def call(conn, _opts) do
		case Guardian.Plug.current_resource(conn) do
  	  nil ->
  	  	login_path = MacLirWeb.Router.Helpers.session_path(conn, :login)

  	  	conn
  	  	|> configure_session(drop: true)
  	  	|> Phoenix.Controller.redirect(to: login_path)
  	  %User{} = user -> 
        assign(conn, :current_user, user)
  	end
	end
end