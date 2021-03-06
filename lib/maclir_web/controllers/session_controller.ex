defmodule MacLirWeb.SessionController do
  use MacLirWeb, :controller

  alias MacLir.{Accounts, Auth}
  alias MacLir.Accounts.Projections.User


  def register(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      %User{} ->
        conn
        |> redirect(to: page_path(conn, :home))
      _ ->
        conn
      	|> assign(:show_header, false)
        |> render("register.html")      
    end
  end

  def login(conn = %{assigns: assigns}, _) do
    case assigns[:current_user] do
      %User{} ->
        conn
        |> redirect(to: page_path(conn, :home))
      _ ->
        conn
        |> assign(:show_header, false)
        |> render("login.html")      
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: session_path(conn, :login))
  end

  def post_register(conn, %{"session" => 
  	%{"phone" => phone, "password" => _, "latitude" => lat, "longitude" => long} = params}) do
  	username = "user_" <> String.replace(phone, "+", "")
  	lat = String.to_float(lat)
  	long = String.to_float(long)

  	params = 
  		params
  		|> Map.put("username", username)
  		|> Map.put("latitude", lat)
  		|> Map.put("longitude", long)

  	with {:ok, %User{} = user} <- Accounts.register_user(params) do
      conn
      |> Guardian.Plug.sign_in(user, :access)
      |> redirect(to: page_path(conn, :home))
    else
    	{:error, :validation_failure, errors} ->
    		IO.inspect errors, label: "session"
	    	conn
	      |> assign(:show_header, false)
	      |> render("register.html")
    end
  end

  def post_login(conn, %{"session" => %{"phone" => phone, "password" => password}}) do
  	with {:ok, %User{} = user} <- Auth.authenticate_by_phone(phone, password) do
        conn
        |> Guardian.Plug.sign_in(user, :access)
        |> redirect(to: page_path(conn, :home))
    else
      {:error, :unauthenticated} ->
      	IO.inspect "unauthenticated", label: "session"
        conn
        |> assign(:show_header, false)
        |> put_flash(:error, "Wrong phone number or password")
	      |> render("login.html")
    end
  end

  def unauthenticated(conn, _) do
    conn
    |> put_flash(:error, "You must be signed in to access this page")
    |> redirect(to: session_path(conn, :login))
  end

  def unauthorized(conn, _) do
    conn
    |> put_flash(:error, "You must be signed in to access this page")
    |> redirect(to: session_path(conn, :login))
  end

end