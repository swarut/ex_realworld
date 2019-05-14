defmodule ExRealworldWeb.Api.UserController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Accounts

  def index(conn, _params) do
    users = Accounts.list_users
    render(conn, "index.json", users: users)
  end
end
