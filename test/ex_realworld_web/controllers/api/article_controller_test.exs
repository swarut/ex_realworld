defmodule ExRealworldWeb.Api.ArticleControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Contents

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list articles" do
    setup [:create_articles]

    test "returns most recent 20 articles", %{conn: conn} do
      conn = get(conn, Routes.api_article_path(conn, :index))
      assert %{"articles" => articles, "articlesCount" => 20} = json_response(conn, 200)
    end
  end

  # describe "list articles with tag filter" do

  # end

  describe "list articles with author filter"do
    setup [:create_article_with_user]

    test "returns most recent articles from the author", %{conn: conn, user: user} do
      conn = get(conn, Routes.api_article_path(conn, :index, author: user.username))
      assert %{"articles" => articles} = json_response(conn, 200)
      # Pin operator didn't work on remote function (user.username)
      # https://stackoverflow.com/questions/34850121/why-forbidden-to-use-a-remote-function-inside-a-guard
      # so we need to evaluate user.username first.
      u = user.username
      assert [%{"author" => %{"username" => ^u}} | _] = articles
    end
  end

  # describe "list articles with favourited filter" do

  # end

  describe "list articles with limit option" do
    setup [:create_articles]

    test "returns specific number of articles", %{conn: conn} do
      conn = get(conn, Routes.api_article_path(conn, :index, limit: 3))
      assert %{"articlesCount" => 3} = json_response(conn, 200)
    end
  end

  # describe "list articles with offset option" do

  # end

  def create_user(_) do
    {:ok, user: insert(:user)}
  end

  def create_article(_) do
    {:ok, article: insert(:article)}
  end

  def create_articles(_) do
    {:ok, articles: insert_list(30, :article)}
  end

  def create_article_with_user(_) do
    insert_list(3, :article)
    user = insert(:user)
    {:ok, [user: user, article: insert(:article, author: user)]}
  end

end
