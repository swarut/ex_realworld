defmodule ExRealworldWeb.Api.UserView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.UserView

  def render("show.json", %{user: user}) do
    %{
      user: render_one(user, UserView, "user.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      email: user.email,
      token: user.token,
      username: user.username,
      bio: user.bio,
      image: user.image
    }
  end

  def render("error.json", %{error: error}) do
    %{
      error: error
    }
  end
end
