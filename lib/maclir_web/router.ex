defmodule MacLirWeb.Router do
  use MacLirWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", MacLirWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :home
    get "/friends", PageController, :friends
    get "/notifs", PageController, :notifs
  end

  # Other scopes may use custom stacks.
  scope "/api", MacLirWeb.API do
    pipe_through :api

    post "/users", UserController, :create
    get "/user", UserController, :current
    post "/users/login", SessionController, :create
  end
end
