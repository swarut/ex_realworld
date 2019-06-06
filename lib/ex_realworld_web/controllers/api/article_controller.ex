defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  def index(conn, params) do
    articles = Contents.list_articles

    conn
    |> render("articles.json", articles: articles)
  end
end
