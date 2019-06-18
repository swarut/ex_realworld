defmodule ExRealworldWeb.Api.ArticleController do
  use ExRealworldWeb, :controller

  alias ExRealworld.Contents

  def index(conn, params) do
    limit = params["limit"]
    offset = params["offset"]
    tag = params["tag"]
    user = conn.assigns[:current_user]
    articles =  case user do
      nil ->
        IO.puts("--------no user")
        Contents.list_recent_articles(tag, limit, offset)
      user ->
        IO.puts("--------with user")
        Contents.list_recent_articles(tag, limit, offset)
        |> Contents.articles_with_is_favourited_flag(user)
    end

    conn
    |> render("articles.json", %{articles: articles})
  end
end
