defmodule ExRealworldWeb.Api.ProfileView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.ProfileView

  def render("profile.json", %{user: user}) do
    %{
      username: user.username,
      bio: user.bio,
      image: user.image
    }
  end

  def render("show.json", %{user: user}) do
    %{
      profile: render_one(user, ProfileView, "profile.json")
    }
  end

end
