defmodule ExRealworldWeb.Api.ProfileControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Accounts
  alias ExRealworld.Accounts.User
  alias ExRealworld.Accounts.Follow
  alias ExRealworld.Repo

  describe "show profile" do
    setup [:create_user]

    test "returns profile data", %{conn: conn, user: user} do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)
      conn = get(conn, Routes.api_profile_path(conn, :show, user.username))
      expected_username = user.username
      assert %{"profile" => %{"username" => ^expected_username}} = json_response(conn, 200)
    end
  end

  describe "follow" do
    setup [:create_follow_users]

    test "creates follow record", %{
      conn: conn,
      user_who_follows: user_who_follows,
      user_who_was_followed: user_who_was_followed
    } do
      followed_user_username = user_who_was_followed.username
      conn = conn |> put_req_header("authorization", "Token " <> user_who_follows.token)
      conn = post(conn, Routes.api_profile_path(conn, :follow, followed_user_username))
      assert %{"profile" => %{"username" => ^followed_user_username, "following" => true}} =
               json_response(conn, 200)
    end
  end

  def create_user(_) do
    {:ok, user} =
      Accounts.create_user(%{
        username: "username2",
        email: "email@email.com",
        password: "password"
      })

    user = Repo.get(User, user.id)
    {:ok, user: user}
  end

  def create_follow_users(_) do
    {:ok, user_who_follows} =
      Accounts.create_user(%{
        username: "manami",
        email: "manami@yowamushi.com",
        password: "password"
      })

    {:ok, user_who_was_followed} =
      Accounts.create_user(%{
        username: "sakamichi",
        email: "sakamichi@yowamushi.com",
        password: "password"
      })

    user_who_follows = Repo.get(User, user_who_follows.id)
    user_who_was_followed = Repo.get(User, user_who_was_followed.id)
    {:ok, user_who_follows: user_who_follows, user_who_was_followed: user_who_was_followed}
  end
end
