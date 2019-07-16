defmodule ExRealworldWeb.Api.ProfileController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Accounts

  plug :authenticate_user when action in [:show, :follow, :unfollow]

  def show(conn, %{"id" => username}) do
    target_user = Accounts.get_user_by(username: username)
    current_user = conn.assigns[:current_user]
    target_user = Accounts.fill_follow_data(current_user, target_user)

    conn
    |> render("show.json", %{user: target_user})
  end

  def follow(conn, %{"username" => username}) do
    target_user = Accounts.get_user_by(%{username: username})
    current_user = conn.assigns[:current_user]

    followed_user = Accounts.follow_user(current_user, target_user)
    followed_user = Accounts.fill_follow_data(current_user, followed_user)
    conn
    |> render("show.json", %{user: followed_user})
  end

  def unfollow(conn, %{"username" => username}) do
    target_user = Accounts.get_user_by(%{username: username})
    current_user = conn.assigns[:current_user]

    unfollowed_user = Accounts.unfollow_user(current_user, target_user)
    unfollowed_user = Accounts.fill_follow_data(current_user, unfollowed_user)
    conn
    |> render("show.json", %{user: unfollowed_user})
  end
end
