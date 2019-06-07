defmodule ExRealworld.Factory do
  use ExMachina.Ecto, repo: ExRealworld.Repo

  alias ExRealworld.Accounts.User
  alias ExRealworld.Contents.Article

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@email.com"),
      password: "password",
      username: sequence(:username, &"nekki_basara_#{&1}")
    }
  end

  def article_factory do
    %Article{
      title: sequence(:titlem, &"A title #{&1}"),
      description: "Fire!",
      body: "Ore no uta o kike!",
      author: build(:user)
    }
  end
end
