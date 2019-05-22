defmodule ExRealworldWeb.Router do
  use ExRealworldWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug ExRealworldWeb.Api.Auth
  end

  scope "/api", ExRealworldWeb.Api, as: :api do
    pipe_through :api

    resources "/users", UserController
    post "/users/login", UserController, :login, as: :login
  end

  scope "/", ExRealworldWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExRealworldWeb do
  #   pipe_through :api
  # end
end
