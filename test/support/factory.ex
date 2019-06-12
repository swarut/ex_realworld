defmodule ExRealworld.Factory do
  use ExMachina.Ecto, repo: ExRealworld.Repo

  alias ExRealworld.Accounts.User
  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.Tag

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@email.com"),
      password: "password",
      username: sequence(:username, &"nekki_basara_#{&1}")
    }
  end

  def tag_factory do
    %Tag{
      title: sequence(:title, &"tag-#{&1}")
    }
  end

  def article_factory do
    %Article{
      title: sequence(:titlem, &"A title #{&1}"),
      description: "Fire!",
      body: "Ore no uta o kike!",
      author: build(:user),
      tag_list: [build(:tag)]
    }
  end
end
