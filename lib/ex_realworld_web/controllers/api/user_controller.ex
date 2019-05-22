defmodule ExRealworldWeb.Api.UserController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Accounts

  action_fallback ExRealworldWeb.FallbackController

  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    render(conn, "user.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end

  def login(conn, _params) do
    user = Accounts.get_last_user
    conn
    |> put_status(:ok)
    |> render("user.json", user: user)
  end

end
