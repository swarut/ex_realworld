defmodule ExRealworldWeb.Api.UserControllerTest do
  use ExRealworldWeb.ConnCase

  # alias ExRealworld.Accounts
  # alias ExRealworld.Users

  @valid_user_attributes %{email: "email@email.com", password: "password"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.api_user_path(conn, :index))
      assert json_response(conn, 200) == %{"users" => []}
    end
  end

  describe "create user" do
    test "creates and returns user if data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create, user: @valid_user_attributes))
      assert %{"user" => user} = json_response(conn, 201)
    end
  end

  describe "login user" do
    test "logins the user and returns user information", %{conn: conn} do
      conn = post(conn, Routes.api_login_path(conn, :login, user: @valid_user_attributes))
      assert %{"user" => user} = json_response(conn, 200)
    end
  end

end

