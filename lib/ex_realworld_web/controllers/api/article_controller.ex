defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  def index(conn, params) do
    limit = params["limit"]
    articles = Contents.list_recent_articles(limit)

    conn
    |> render("articles.json", articles: articles)
  end
end
