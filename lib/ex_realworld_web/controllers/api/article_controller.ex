defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  plug :authenticate_user when action in [:feed, :update]

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
    {:ok, article} = Contents.create_article(params["article"])

    conn
    |> render("show.json", %{article: article})
  end

  def show(conn, params) do
    slug = params["id"]
    article = Contents.get_article_by_slug(slug)

    conn
    |> render("show.json", %{article: article})
  end

  def update(conn, params) do
    {:ok, article} =
      case conn.assigns[:current_user] do
        nil ->
          {:ok, nil}

        _ ->
          Contents.update_article(Contents.get_article_by_slug(params["id"]), params["article"])
      end

    conn
    |> render("show.json", %{article: article})
  end

  def feed(conn, params) do
    offset = params["offset"]
    limit = params["limit"]

    current_user = conn.assigns[:current_user]

    articles =
      case current_user do
        nil -> []
        current_user -> Contents.get_feed_by_user_id(current_user.id, offset, limit)
      end

    conn
    |> render("articles.json", %{articles: articles})
  end

  def favorite(conn, params) do
    current_user = conn.assigns[:current_user]
    slug = params["id"]
    article = case current_user do
      nil -> nil
      _ -> Contents.get_article_by_slug(slug)
    end

    Contents.create_favourite(%{user_id: current_user.id, article_id: article.id})
    article = Contents.get_article!(article.id) |> Contents.article_with_is_favourited_flag(current_user)

    conn
    |> render("show.json", %{article: article})
  end
end
