defmodule ExRealworldWeb.Api.UserControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Accounts

  @valid_user_attributes %{email: "email@email.com", password: "password"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user with valid data" do
    test "creates and returns user", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @valid_user_attributes)
      assert %{"user" => user} = json_response(conn, 201)
      assert user["email"] == @valid_user_attributes[:email]
    end
  end

  describe "login user with right credential" do
    setup [:create_user]

    test "logins the user and returns user information", %{conn: conn} do
      conn = post(conn, Routes.api_login_path(conn, :login, user: @valid_user_attributes))
      assert %{"user" => user} = json_response(conn, 200)
      assert user["email"] == @valid_user_attributes.email
    end
  end

  describe "login user with incorrect credential" do
    setup [:create_user]

    test "with wrong credential, get error", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.api_login_path(conn, :login,
            user: Map.merge(@valid_user_attributes, %{password: "2"})
          )
        )

      assert %{"user" => user} = json_response(conn, 200)
      assert user["email"] == @valid_user_attributes.email
    end
  end

  describe "index with valid token" do
    setup [:create_user]

    test "returns current user", %{conn: conn, user: user} do
      index_conn = conn |> put_req_header("authorization", "Token " <> user.token)
      index_conn = get(index_conn, Routes.api_user_path(conn, :index))
      assert %{"user" => user} = json_response(index_conn, 200)
      assert user["email"] == @valid_user_attributes.email
    end
  end

  describe "index with invalid token" do
    setup [:create_user]

    test "returns error", %{conn: conn} do
      index_conn = conn |> put_req_header("authorization", "Token incorrect token")
      index_conn = get(index_conn, Routes.api_user_path(conn, :index))
      assert %{"error" => "unauthorized"} = json_response(index_conn, 401)
    end
  end

  describe "update user with correct attributes" do
    setup [:create_user]

    test "updates and returned updated user", %{conn: conn, user: user} do
      update_conn = conn |> put_req_header("authorization", "Token " <> user.token)

      update_conn =
        put(update_conn, Routes.api_user_path(conn, :update, user), user: %{bio: "my bio"})

      assert %{"user" => user} = json_response(update_conn, 200)
      assert user["bio"] == "my bio"
    end
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@valid_user_attributes)
    user
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
