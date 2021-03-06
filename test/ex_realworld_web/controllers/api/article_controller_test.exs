defmodule ExRealworldWeb.Api.ArticleControllerTest do
  use ExRealworldWeb.ConnCase

  alias ExRealworld.Repo
  alias ExRealworld.Accounts
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

    test "returns most recent articles with favorited flag", %{
      conn: conn,
      user: user,
      article: _article
    } do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)
      authorized_conn = get(conn, Routes.api_article_path(conn, :index))
      assert %{"articles" => articles} = json_response(authorized_conn, 200)
      assert [%{"favorited" => true}] = articles
    end
  end

  describe "list articles with tag filter" do
    setup [:create_articles_with_tag]

    test "returns most recent articles that use a tag", %{conn: conn, tag: tag} do
      conn = get(conn, Routes.api_article_path(conn, :index, tag: tag))
      assert %{"articlesCount" => 1} = json_response(conn, 200)
    end
  end

  describe "list articles with author filter" do
    setup [:create_article_with_user]

    test "returns most recent articles from the author", %{conn: conn, user: user} do
      conn = get(conn, Routes.api_article_path(conn, :index, author: user.username))
      assert %{"articles" => articles} = json_response(conn, 200)
      # Pin operator didn't work on remote function (user.username)
      # https://stackoverflow.com/questions/34850121/why-forbidden-to-use-a-remote-function-inside-a-guard
      # so we need to evaluate user.username first.
      username = user.username
      assert [%{"author" => %{"username" => ^username}} | _] = articles
    end
  end

  describe "list articles with favourited filter" do
    setup [:create_articles_with_is_favourited]

    test "returns most recent articles favorited by specific user", %{conn: conn, user: user} do
      conn = get(conn, Routes.api_article_path(conn, :index, favorited: user.username))
      assert %{"articles" => articles} = json_response(conn, 200)
      username = user.username
      assert [%{"favourited_by" => [%{"username" => ^username} | _]}] = articles
    end

    test "returns nothing if specific user has no favourite", %{conn: conn} do
      conn = get(conn, Routes.api_article_path(conn, :index, favorited: "someoneelse"))
      assert %{"articles" => []} = json_response(conn, 200)
    end
  end

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

  describe "get article by slug" do
    setup [:create_article]

    test "returns article with specific slug", %{conn: conn, article: article} do
      conn = get(conn, Routes.api_article_path(conn, :show, article.slug))
      assert %{"article" => a} = json_response(conn, 200)
      assert a["id"] == article.id
      assert length(a["comments"]) == 1
    end
  end

  describe "create article" do
    test "adds new article and return it", %{conn: conn} do
      {title, description, body} = {"title", "description", "body"}

      conn =
        post(conn, Routes.api_article_path(conn, :create),
          article: %{title: title, description: description, body: body}
        )

      assert %{"article" => article} = json_response(conn, 200)
      assert article["title"] == title
    end
  end

  describe "update article" do
    setup [:create_article_with_user]

    test "updates the article and return it", %{conn: conn, user: user, article: article} do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)

      conn =
        put(conn, Routes.api_article_path(conn, :update, article.slug), article: %{title: "new title"})

      assert %{"article" => a} = json_response(conn, 200)
      assert a["title"] == "new title"
      assert a["slug"] == "new-title"
    end
  end

  # TODO: need to implement follow first
  describe "feed" do
    setup [:create_articles_by_followed_user]

    test "lists article from followed users", %{conn: conn, user: user, article1: article} do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)
      conn = get(conn, Routes.api_article_path(conn, :feed))
      assert %{"articles" => articles, "articlesCount" => 1} = json_response(conn, 200)
    end
  end

  describe "favorite" do
    setup [:create_article_with_user]

    test "favourites article", %{conn: conn, user: user, article: article} do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)
      conn = post(conn, Routes.api_article_path(conn, :favourite, article.slug))
      assert %{"article" => a} = json_response(conn, 200)
      assert a["favorited"] == true
    end
  end

  describe "unfavorite" do
    setup [:create_articles_with_is_favourited]

    test "unfavourites article", %{conn: conn, user: user, article: article} do
      conn = conn |> put_req_header("authorization", "Token " <> user.token)
      conn = delete(conn, Routes.api_article_path(conn, :favourite, article.slug))
      assert %{"article" => a } = json_response(conn, 200)
      assert a["favorited"] == false
    end
  end

  # describe "comments" do
  #   setup [:create_article_with_comments]

  #   test "returns comment of the article", %{conn: conn, article: article} do

  #    end
  # end

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

    {:ok, user} =
      Accounts.create_user(%{
        username: "username",
        email: "email@email.com",
        password: "password"
      })

    user = Repo.get(User, user.id)
    {:ok, [user: user, article: insert(:article, author: user)]}
  end

  def create_articles_with_tag(_) do
    insert_list(3, :article)
    article = insert(:article)
    %Article{tag_list: [%Tag{title: tag} | _]} = article
    {:ok, tag: tag}
  end

  def create_articles_with_is_favourited(_) do
    {:ok, user} =
      Accounts.create_user(%{
        username: "username",
        email: "email@email.com",
        password: "password"
      })

    user = Repo.get(User, user.id)
    article = insert(:article, favourited_by: [user])
    {:ok, [user: user, article: article]}
  end

  def create_articles_by_followed_user(_) do
    {:ok, user} =
      Accounts.create_user(%{
        username: "ray",
        email: "ray@macross7.com",
        password: "password"
      })

    {:ok, followed_user} =
      Accounts.create_user(%{
        username: "verfedus",
        email: "verfedus@macross7.com",
        password: "password"
      })

    {:ok, non_followed_user} =
      Accounts.create_user(%{
        username: "gemlin",
        email: "gemlin@macross7.com",
        password: "password"
      })

    user = Repo.get(User, user.id)
    followed_user = Repo.get(User, followed_user.id)
    non_followed_user = Repo.get(User, non_followed_user.id)
    Accounts.follow_user(user, followed_user)

    author1 = struct(User, Map.from_struct(followed_user))
    author2 = struct(User, Map.from_struct(non_followed_user))
    article1 = insert(:article, author: author1)
    insert(:article, author: author2)

    {:ok, [user: user, article1: article1]}
  end

end
