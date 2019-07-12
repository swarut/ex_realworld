defmodule ExRealworldWeb.Api.ProfileControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Accounts.User
  alias ExRealworld.Follow.User

  describe "show profile" do
    setup [:create_user]
    test "return profile data", %{conn: conn, user: user} do
      conn = get(conn, Routes.api_profile_path(conn, :show, user.username))
      assert %{"profile" => profile} = json_response(200, conn)
    end
  end

  def create_user(_) do
    {:ok, user: insert(:accounts_user)}
  end
end
