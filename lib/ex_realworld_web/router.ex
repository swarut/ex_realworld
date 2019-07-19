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

    resources "/users", UserController, except: [:index]
    post "/users/login", UserController, :login, as: :login
    get "/user", UserController, :index
    put "/user", UserController, :update

    resources "/profiles", ProfileController, only: [:show]
    post "/profiles/:username/follow", ProfileController, :follow
    delete "/profiles/:username/follow", ProfileController, :unfollow

    get "/articles", ArticleController, :index
    get "/articles/feed", ArticleController, :feed
    get "/articles/:slug", ArticleController, :show
    post "/articles", ArticleController, :create
    put "/articles", ArticleController, :update
    delete "/articles", ArticleController, :delete
    # post "/articles/:slug/comments", ArticleController, :add_comment
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
