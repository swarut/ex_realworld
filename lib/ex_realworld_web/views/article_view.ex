defmodule ExRealworldWeb.ArticleView do
  use ExRealworldWeb, :view
  alias ExRealworldWeb.ArticleView

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      title: article.title,
      slug: article.slug,
      description: article.description,
      body: article.body,
      favourites_count: article.favourites_count}
  end
end
