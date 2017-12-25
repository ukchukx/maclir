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
  pipeline :socket_auth do
    plug MacLirWeb.Plug.SocketToken
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: MacLirWeb.SessionController
    plug MacLirWeb.Plug.EnsureAuthenticated # because Guardian isn't doing it's job
  end

  scope "/", MacLirWeb do
    pipe_through [:browser, :socket_auth]


    get "/login", SessionController, :login
    post "/login", SessionController, :post_login
    get "/logout", SessionController, :logout
    get "/logout", SessionController, :logout

    get "/register", SessionController, :register
    post "/register", SessionController, :post_register
  end

  scope "/", MacLirWeb do
    pipe_through [:browser, :browser_auth, :socket_auth]
    
    get "/", PageController, :home
    get "/friends", PageController, :friends
    post "/friends", PageController, :post_friend_request
    post "/friends/remove", PageController, :post_remove_friend
    get "/friend-requests", PageController, :friend_requests
    post "/friend-requests/cancel", PageController, :post_cancel_friend_request
    post "/friend-requests/reject", PageController, :post_reject_friend_request
    post "/friend-requests/accept", PageController, :post_accept_friend_request
    get "/profile", PageController, :profile
    post "/profile", PageController, :post_profile
  end

  # Other scopes may use custom stacks.
  scope "/api", MacLirWeb.API do
    pipe_through :api

    post "/users", UserController, :create
    get "/user", UserController, :current
    put "/user", UserController, :update
    post "/users/login", SessionController, :create
  end
end
