defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  def index(conn, _params) do
    articles = Contents.list_articles

    conn
    |> render("articles.json", articles: articles)
  end
end
