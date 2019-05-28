defmodule ExRealworldWeb.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents
  alias ExRealworld.Contents.Article

  action_fallback ExRealworldWeb.FallbackController

  def index(conn, _params) do
    articles = Contents.list_articles()
    render(conn, "index.json", articles: articles)
  end

  def create(conn, %{"article" => article_params}) do
    with {:ok, %Article{} = article} <- Contents.create_article(article_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Contents.get_article!(id)
    render(conn, "show.json", article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Contents.get_article!(id)

    with {:ok, %Article{} = article} <- Contents.update_article(article, article_params) do
      render(conn, "show.json", article: article)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Contents.get_article!(id)

    with {:ok, %Article{}} <- Contents.delete_article(article) do
      send_resp(conn, :no_content, "")
    end
  end
end
