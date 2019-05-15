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
    # case Accounts.create_user(user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_status(:created)
    #     |> render("user.json", user: user)
    #   {:error, changeset} ->
    #     conn
    #     |> put_status(:bad_request)
    #     |> text("yo")
    # end
  end
end
