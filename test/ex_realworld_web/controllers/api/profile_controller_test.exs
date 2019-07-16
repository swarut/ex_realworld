defmodule ExRealworldWeb.Api.ProfileControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Accounts
  alias ExRealworld.Accounts.User
  alias ExRealworld.Accounts.Follow
  alias ExRealworld.Repo

  import Ecto.Query, warn: false

  describe "show own profile" do
    setup [:create_user]

    test "returns profile data", %{conn: conn, user: user} do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)
      conn = get(conn, Routes.api_profile_path(conn, :show, user.username))
      expected_username = user.username

      assert %{"profile" => %{"username" => ^expected_username, "following" => false}} =
               json_response(conn, 200)
    end
  end

  describe "show target user profile" do
    setup [:create_follow_users]

    test "returns profile data with following flag as true for followed user", %{
      conn: conn,
      user_who_follows: user_who_follows,
      user_who_was_followed: user_who_was_followed
    } do
      conn = conn |> put_req_header("authorization", "Token " <> user_who_follows.token)
      conn = get(conn, Routes.api_profile_path(conn, :show, user_who_was_followed.username))
      expected_username = user_who_was_followed.username

      assert %{"profile" => %{"username" => ^expected_username, "following" => true}} =
               json_response(conn, 200)
    end

    test "returns profile data with following flag as flase for non-followed user", %{
      conn: conn,
      user_who_follows: user_who_follows,
      user_who_was_not_followed: user_who_was_not_followed
    } do
      conn = conn |> put_req_header("authorization", "Token " <> user_who_follows.token)
      conn = get(conn, Routes.api_profile_path(conn, :show, user_who_was_not_followed.username))
      expected_username = user_who_was_not_followed.username

      assert %{"profile" => %{"username" => ^expected_username, "following" => false}} =
               json_response(conn, 200)
    end
  end

  describe "follow" do
    setup [:create_follow_users]

    test "creates follow record", %{
      conn: conn,
      user_who_follows: user_who_follows,
      user_who_was_not_followed: user_who_was_not_followed
    } do
      followed_user_username = user_who_was_not_followed.username
      conn = conn |> put_req_header("authorization", "Token " <> user_who_follows.token)
      conn = post(conn, Routes.api_profile_path(conn, :follow, followed_user_username))

      assert %{"profile" => %{"username" => ^followed_user_username, "following" => true}} =
               json_response(conn, 200)
    end
  end

  describe "unfollow" do
    setup [:create_follow_users]

    test "removes follow record", %{
      conn: conn,
      user_who_follows: user_who_follows,
      user_who_was_followed: user_who_was_followed
    } do
      unfollowed_user_username = user_who_was_followed.username
      conn = conn |> put_req_header("authorization", "Token " <> user_who_follows.token)
      conn = delete(conn, Routes.api_profile_path(conn, :unfollow, unfollowed_user_username))

      assert %{"profile" => %{"username" => ^unfollowed_user_username, "following" => false}} =
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

    {:ok, user_who_was_not_followed} =
      Accounts.create_user(%{
        username: "kinjou",
        email: "kinjou@yowamushi.com",
        password: "password"
      })

    user_who_follows = Repo.get(User, user_who_follows.id)
    user_who_was_followed = Repo.get(User, user_who_was_followed.id)
    user_who_was_not_followed = Repo.get(User, user_who_was_not_followed.id)

    Accounts.follow_user(user_who_follows, user_who_was_followed)

    {:ok,
     user_who_follows: user_who_follows,
     user_who_was_followed: user_who_was_followed,
     user_who_was_not_followed: user_who_was_not_followed}
  end
end
