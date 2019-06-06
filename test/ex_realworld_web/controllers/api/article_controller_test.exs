defmodule ExRealworldWeb.Api.ArticleControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Contents
  alias ExRealworld.Articles
  alias ExRealworld.Accounts
  alias ExRealworld.Accounts.User

  @valid_article_attributes %{title: "A title", description: "Fire!", body: "Ore no uta o kike!"}
  @valid_user_attributes %{email: "email@email.com", password: "password", username: "nekki_basara"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list articles" do
    setup [:create_article]

    test "returns most recent 20 articles", %{conn: conn} do
      conn = get(conn, Routes.api_article_path(conn, :index))
      assert %{"articles" => articles, "articlesCount" => 1} = json_response(conn, 200)
    end
  end

  # describe "list articles with tag filter" do

  # end

  describe "list articles with author filter"do
    setup [:create_user_with_article]

    test "returns most recent articles from the author", %{conn: conn, user: user} do
      IO.puts("user --- #{inspect user}")
      conn = get(conn, Routes.api_article_path(conn, :index, author: user.username))
      assert %{"articles" => articles, "articlesCount" => 1} = json_response(conn, 200)
      # Pin operator didn't work on remote function (user.username)
      # https://stackoverflow.com/questions/34850121/why-forbidden-to-use-a-remote-function-inside-a-guard
      # so we need to evaluate user.username first.
      u = user.username
      assert [%{"author" => %{"username" => ^u}}] = articles
    end
  end

  # describe "list articles with favourited filter" do

  # end

  # describe "list articles with limit option" do

  # end

  # describe "list articles with offset option" do

  # end

  def fixture(:article, %User{id: id}) do
    {:ok, article} = Contents.create_article(Map.merge(@valid_article_attributes, %{user_id: id}))
    article
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@valid_user_attributes)
    user
  end

  def create_article(_) do
    article = fixture(:article)
    {:ok, article: article}
  end

  def create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  def create_user_with_article(_) do
    user = fixture(:user)
    article = fixture(:article, user)
    {:ok, [user: user, article: article]}
  end

end
