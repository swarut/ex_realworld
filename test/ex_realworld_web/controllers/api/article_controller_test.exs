defmodule ExRealworldWeb.Api.ArticleControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Contents
  alias ExRealworld.Articles

  @valid_article_attributes %{title: "A title", description: "Fire!", body: "Ore no uta o kike!"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list articles" do
    setup [:create_article]

    test "returns most recent 20 artiles", %{conn: conn} do
      conn = get(conn, Routes.api_article_path(conn, :index))
      assert %{"articles" => articles, "articlesCount" => 1} = json_response(conn, 200)
    end
  end

  describe "list articles with tag filter" do

  end

  describe "list articles with favourited filter" do

  end

  describe "list articles with limit option" do

  end

  describe "list articles with offset option" do

  end

  def fixture(:article) do
    {:ok, article} = Contents.create_article(@valid_article_attributes)
    article
  end

  defp create_article(_) do
    article = fixture(:article)
    {:ok, article: article}
  end

end
