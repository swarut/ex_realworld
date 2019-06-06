defmodule ExRealworldWeb.Api.ArticleControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Contents
  alias ExRealworld.Articles
  alias ExRealworld.Accounts

  @valid_article_attributes %{title: "A title", description: "Fire!", body: "Ore no uta o kike!"}
  @valid_user_attributes %{email: "email@email.com", password: "password"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "list articles" do
  #   setup [:create_article]

  #   test "returns most recent 20 artiles", %{conn: conn} do
  #     conn = get(conn, Routes.api_article_path(conn, :index))
  #     assert %{"articles" => articles, "articlesCount" => 1} = json_response(conn, 200)
  #   end
  # end

  # describe "list articles with tag filter" do

  # end

  describe "list articles with author filter"do
    setup context do
      # {:ok, user} = create_user()
      # {:ok, article} = create_article(%{user_id: user.id})
      # {:ok, %{user: user, article: article}}
      create_article(context)
    end

    test "returns most recent 20 artiles", %{conn: conn, article: article} do
      IO.puts("user --- #{inspect article}")
      # conn = get(conn, Routes.api_article_path(conn, :index, author: "aaa"))
      # assert %{"articles" => articles, "articlesCount" => 1} = json_response(conn, 200)
    end
  end

  # describe "list articles with favourited filter" do

  # end

  # describe "list articles with limit option" do

  # end

  # describe "list articles with offset option" do

  # end

  def fixture(:article, params) do
    {:ok, article} = Contents.create_article(Map.merge(@valid_article_attributes, params))
    article
  end

  def create_article(params) do
    article = fixture(:article, params)
    {:ok, article: article}
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@valid_user_attributes)
    user
  end

  def create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

end
