defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  def index(conn, params) do
    limit = params["limit"]
    offset = params["offset"]
    tag = params["tag"]
    articles = Contents.list_recent_articles(tag, limit, offset)

    conn
    |> render("articles.json", articles: articles)
  end
end
