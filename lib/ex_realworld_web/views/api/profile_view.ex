defmodule ExRealworldWeb.Api.ProfileView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.ProfileView

  def render("profile.json", %{user: user}) do
    %{
      username: user.username,
      bio: user.bio,
      image: user.image,
      following: user.following
    }
  end

  def render("show.json", %{user: user}) do
    %{
      # The below expression is not working as it assume data key to be :profile
      # profile: render_one(user, ProfileView, "profile.json")
      # To make it works, there are two options
      # * Explicitly specify key using :as
      #     profile: render_one(user, ProfileView, "profile.json", as: :user)
      # * Or use the full render function
      #     profile: render(ProfileView, "profile.json", user: user)
      profile: render_one(user, ProfileView, "profile.json", as: :user)
    }
  end
end
