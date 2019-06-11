defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  def index(conn, params) do
    limit = params["limit"]
    offset = params["offset"]
    articles = Contents.list_recent_articles(limit, offset)

    conn
    |> render("articles.json", articles: articles)
  end
end
