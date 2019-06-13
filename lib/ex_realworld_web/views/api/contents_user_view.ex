defmodule ExRealworldWeb.Api.ContentsUserView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.ContentsUserView

  def render("show.json", %{contents_user: user}) do
    %{
      user: render_one(user, ContentsUserView, "user.json")
    }
  end

  def render("user.json", %{contents_user: user}) do
    %{
      email: user.email,
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
