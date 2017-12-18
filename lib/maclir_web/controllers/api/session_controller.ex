defmodule MacLirWeb.API.SessionController do
  use MacLirWeb, :controller

  alias MacLir.Auth
  alias MacLir.Accounts.Projections.User

  action_fallback MacLirWeb.API.FallbackController

  def create(conn, %{"user" => %{"id" => id, "password" => password}}) do
    auth_fn = 
      case String.match?(id, ~r/\S+@\S+\.\S+/) do # check if id is email
        true -> &Auth.authenticate_by_email/2
        false -> &Auth.authenticate_by_phone/2 
      end

    with {:ok, %User{} = user} <- auth_fn.(id, password),
      {:ok, jwt} <- generate_jwt(user) do
        conn
        |> put_status(:created)
        |> render(MacLirWeb.API.UserView, "show.json", user: user, jwt: jwt)
    else
      {:error, :unauthenticated} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MacLirWeb.API.ValidationView, "error.json", errors: %{"id or password" => ["is invalid"]})
    end
  end
end