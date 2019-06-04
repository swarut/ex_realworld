defmodule ExRealworldWeb.Api.ArticleControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Contents
  alias ExRealworld.Articles

  describe "list articles" do

  end

  def fixture(:article) do
    {:ok, article} = Contets.create_article(@valid_article_attributes)
    user
  end

  defp create_article(_) do
    article = fixture(:article)
    {:ok, article: article}
  end

end
