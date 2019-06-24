defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  def index(conn, params) do
    favourited_by = params["favorited"]
    offset = params["offset"]
    limit = params["limit"]
    tag = params["tag"]

    user = conn.assigns[:current_user]

    articles =
      case user do
        nil ->
          Contents.list_recent_articles(tag, favourited_by, limit, offset)

        user ->
          Contents.list_recent_articles(tag, favourited_by, limit, offset)
          |> Contents.articles_with_is_favourited_flag(user)
      end

    conn
    |> render("articles.json", %{articles: articles})
  end

  def create(conn, params) do
    article =
      with {:ok, article} <- Contents.create_article(params["article"]) do
        article |> ExRealworld.Repo.preload([:author, :tag_list, :favourited_by])
      end

    conn
    |> render("show.json", %{article: article})
  end
end
