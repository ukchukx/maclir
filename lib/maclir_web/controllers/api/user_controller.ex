defmodule MacLirWeb.API.UserController do
  use MacLirWeb, :controller

  alias MacLir.Accounts
  alias MacLir.Accounts.Projections.User
  use Guardian.Phoenix.Controller

  action_fallback MacLirWeb.API.FallbackController

  plug Guardian.Plug.EnsureAuthenticated, %{handler: MacLirWeb.ErrorHandler} when action in [:current]
  plug Guardian.Plug.EnsureResource, %{handler: MacLirWeb.ErrorHandler} when action in [:current]

  def create(conn, %{"user" => user_params}, _user, _claims) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params),
      {:ok, jwt} = generate_jwt(user) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user, jwt: jwt)
    end
  end

  def current(conn, _params, user, _claims) do
    jwt = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user, jwt: jwt)
  end

end
