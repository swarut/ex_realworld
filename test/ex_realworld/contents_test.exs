defmodule ExRealworld.ContentsTest do
  use ExRealworld.DataCase

  alias ExRealworld.Contents

  describe "articles" do
    alias ExRealworld.Contents.Article

    @valid_attrs %{
      body: "some body",
      description: "some description",
      favourites_count: 42,
      slug: "some slug",
      title: "some title"
    }
    @update_attrs %{
      body: "some updated body",
      description: "some updated description",
      favourites_count: 43,
      slug: "some updated slug",
      title: "some updated title"
    }
    @invalid_attrs %{body: nil, description: nil, favourites_count: nil, slug: nil, title: nil}

    def article_fixture(attrs \\ %{}) do
      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_article()

      article
    end

    def create_article(_) do
      user = insert(:contents_user)
      {:ok, [article: insert(:article, favourited_by: [user]), user: user]}
    end

    setup [:create_article]

    test "list_articles/0 returns all articles", %{article: article} do
      assert Enum.map(Contents.list_articles(), fn article -> article.id end) == [article.id]
    end

    test "get_article!/1 returns the article with given id", %{article: article} do
      assert Contents.get_article!(article.id).id == article.id
    end

    test "create_article/1 with valid data creates a article" do
      assert {:ok, %Article{} = article} = Contents.create_article(@valid_attrs)
      assert article.body == "some body"
      assert article.description == "some description"
      assert article.favourites_count == 42
      assert article.slug == "some-title"
      assert article.title == "some title"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article", %{article: article} do
      assert {:ok, %Article{} = article} = Contents.update_article(article, @update_attrs)
      assert article.body == "some updated body"
      assert article.description == "some updated description"
      assert article.favourites_count == 43
      assert article.slug == "some-updated-title"
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset", %{article: article} do
      assert {:error, %Ecto.Changeset{}} = Contents.update_article(article, @invalid_attrs)
      assert article.id == Contents.get_article!(article.id).id
    end

    test "delete_article/1 deletes the article", %{article: article} do
      assert {:ok, %Article{}} = Contents.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset", %{article: article} do
      assert %Ecto.Changeset{} = Contents.change_article(article)
    end
  end
end
