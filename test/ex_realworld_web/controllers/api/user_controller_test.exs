defmodule ExRealworldWeb.Api.UserControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Accounts
  alias ExRealworld.Users

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "/api/users" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, "/api/users")
      assert json_response(conn, 200) == []
    end
  end

end
