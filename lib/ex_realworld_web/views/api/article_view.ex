defmodule ExRealworldWeb.Api.ArticleView do
  use ExRealworldWeb, :view

  alias ExRealworldWeb.Api.ArticleView

  def render("articles.json", %{articles: articles}) do
    render_many(articles, ArticleView, "article.json")
  end

  def render("article.json", %{article: article}) do
    %{
      article: %{
        tile: article.title,
        slug: article.slug,
        description: article.description,
        body: article.body,
        createdAt: article.inserted_at,
        updatedAt: article.updated_at,
        favouritesCount: article.favourites_count
      }
    }
  end

  def render("error.json", %{error: error}) do
    %{
      error: error
    }
  end
end
