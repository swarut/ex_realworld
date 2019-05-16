defmodule ExRealworldWeb.Api.UserController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Accounts

  action_fallback ExRealworldWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end

  def login(conn, _params) do
    conn
    |> text("yo")
  end
end
