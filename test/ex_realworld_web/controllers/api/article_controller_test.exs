defmodule ExRealworldWeb.Api.ArticleControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Contents
  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.Tag
  alias ExRealworld.Contents.User

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

  describe "list articles with authentication" do
    setup [:create_articles_with_is_favourited]

    test "returns most recent 20 articles with is_favourited flag", %{conn: conn, user: user, article: _article} do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)
      authorized_conn = get(conn, Routes.api_article_path(conn, :index))
      assert %{"articles" => articles} = json_response(authorized_conn, 200)
      assert [%{"is_favourited" => true}] = articles
    end
  end

  describe "list articles with tag filter" do
    setup [:create_articles_with_tag]

    test "return most recent articles that use a tag", %{conn: conn, tag: tag} do
      conn = get(conn, Routes.api_article_path(conn, :index, tag: tag))
      assert %{"articlesCount" => 1} = json_response(conn, 200)
    end
  end

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

  describe "list articles with offset option" do
    setup [:create_three_articles]

    test "returns articles with offset", %{conn: conn} do
      conn = get(conn, Routes.api_article_path(conn, :index, offset: 1))
      assert %{"articlesCount" => 2} = json_response(conn, 200)
    end
  end

  def create_user(_) do
    {:ok, user: insert(:contents_user)}
  end

  def create_article(_) do
    {:ok, article: insert(:article)}
  end

  def create_articles(_) do
    {:ok, articles: insert_list(30, :article)}
  end

  def create_three_articles(_) do
    {:ok, articles: insert_list(3, :article)}
  end

  def create_article_with_user(_) do
    insert_list(3, :article)
    user = insert(:contents_user)
    {:ok, [user: user, article: insert(:article, author: user)]}
  end

  def create_articles_with_tag(_) do
    insert_list(3, :article)
    article = insert(:article)
    %Article{tag_list: [%Tag{title: tag} | _]} = article
    {:ok, tag: tag}
  end

  def create_articles_with_is_favourited(_) do
    {:ok, user} = ExRealworld.Accounts.create_user(%{email: "email@email.com", password: "password"})
    user = ExRealworld.Repo.get(User, user.id)
    article = insert(:article, favourited_by: [user])
    {:ok, [user: user, article: article]}
  end

end
