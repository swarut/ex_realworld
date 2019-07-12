defmodule ExRealworldWeb.Api.ProfileController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Accounts

  def show(conn, %{"id" => username}) do
    user = Accounts.get_user_by(username: username)
    conn
    |> render("show.json", %{user: user})
  end

end
