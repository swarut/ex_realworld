defmodule ExRealworldWeb.Api.ArticleView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.ArticleView
  alias ExRealworldWeb.Api.ContentsUserView

  def render("articles.json", %{articles: articles}) do
    %{
      articles: render_many(articles, ArticleView, "article.json"),
      articlesCount: length(articles)
    }
  end

  # NOTE: this view function depends on the article to be preloaded with favourited_by
  # association. Let's figure out how to make it independent so that it can be called
  # even the article is not preloaded.
  def render("article.json", %{article: article}) do
    %{
      id: article.id,
      title: article.title,
      slug: article.slug,
      description: article.description,
      body: article.body,
      createdAt: naive_datetime_to_iso_8601(article.inserted_at),
      updatedAt: naive_datetime_to_iso_8601(article.updated_at),
      favoritesCount: length(article.favourited_by),
      tagList: article.tag_list |> Enum.map(fn(t) -> t.title end),
      author: render_one(article.author, ContentsUserView, "user.json"),
      favourited_by: render_many(article.favourited_by, ContentsUserView, "user.json"),
      favorited: article.is_favourited
    }
  end

  def render("show.json", %{article: article}) do
    %{ article: render_one(article, ArticleView, "article.json")}
  end

  def render("error.json", %{error: error}) do
    %{
      error: error
    }
  end

  defp naive_datetime_to_iso_8601(datetime) do
    datetime
    |> Map.put(:microsecond, {elem(datetime.microsecond, 0), 3})
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.to_iso8601()
  end

end
