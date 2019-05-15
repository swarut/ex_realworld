defmodule ExRealworldWeb.Api.UserView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      user: %{
        email: user.email,
        token: user.token,
        username: user.username,
        bio: user.bio,
        image: user.image
      }
    }
  end
end
