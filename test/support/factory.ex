defmodule ExRealworld.Factory do
  use ExMachina.Ecto, repo: ExRealworld.Repo

  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.Favourite
  alias ExRealworld.Contents.Tag

  def accounts_user_factory do
    %ExRealworld.Accounts.User{
      email: sequence(:email, &"email-#{&1}@email.com"),
      password: "password",
      username: sequence(:username, &"nekki_basara_#{&1}")
    }
  end

  def contents_user_factory do
    %ExRealworld.Contents.User{
      email: sequence(:email, &"email-#{&1}@email.com"),
      username: sequence(:username, &"nekki_basara_#{&1}")
    }
  end

  def tag_factory do
    %Tag{
      title: sequence(:title, &"tag-#{&1}")
    }
  end

  def favourite_factory do
    %Favourite {
      user: build(:user),
      article: build(:article)
    }
  end

  def article_factory do
    %Article{
      title: sequence(:title, &"A title #{&1}"),
      description: "Fire!",
      body: "Ore no uta o kike!",
      author: build(:contents_user),
      tag_list: [build(:tag)],
      favourited_by: [build(:contents_user)],
      slug: sequence(:slug, &"A slug #{&1}"),
    }
  end
end
