defmodule ExRealworldWeb.Api.UserView do
  use ExRealworldWeb, :view

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
