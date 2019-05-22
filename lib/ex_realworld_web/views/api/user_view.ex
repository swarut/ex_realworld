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

  def render("error.json", %{error: error}) do
    %{
      error: error
    }
  end
end
