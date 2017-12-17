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
  end

  scope "/", MacLirWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/friends", PageController, :friends
    get "/notifs", PageController, :notifs
  end

  # Other scopes may use custom stacks.
  scope "/api", MacLirWeb.API do
    pipe_through :api

    post "/users", UserController, :create
  end
end
