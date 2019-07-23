defmodule ExRealworld.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias ExRealworld.Repo

  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.Favourite

  @max_recent_articles 20

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(Article, preload: :author)
  end

  @doc """
  Get the most recent 20 articles
  """
  def list_recent_articles(tag, favourited_by, limit, offset) do
    limit = limit || @max_recent_articles

    query =
      from(a in Article)
      |> Article.with_tag(tag)
      |> Article.with_favourited_by(favourited_by)
      |> Article.recent()
      |> Article.limit(limit)
      |> Article.offset(offset)

    # TODO: Investigate more why the below code doesn't work.
    # Repo.all(query, preload: :author)
    Repo.all(query) |> Repo.preload([:author, :tag_list, :favourited_by])
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id),
    do: Repo.get!(Article, id) |> Repo.preload([:author, :tag_list, :favourited_by])

  def get_article_by_slug(slug),
    do: Repo.get_by(Article, slug: slug) |> Repo.preload([:author, :tag_list, :favourited_by])

  @doc """
  Get feed for a specific user

  ## Examples

      iex> get_feed_by_user_id(1)
      [%Article{}, %Article{}]

  """
  def get_feed_by_user_id(user_id, limit, offset) do
    query =
      from(a in Article)
      |> Article.from_followed_users_of_user(user_id)
      |> Article.recent()
      |> Article.limit(limit)
      |> Article.offset(offset)

    # sql = Repo.to_sql(:all, query)
    # IO.puts("SQL = #{inspect(sql)}")

    Repo.all(query) |> Repo.preload([:author, :tag_list, :favourited_by])
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    article =
      %Article{}
      |> Article.changeset(attrs)
      |> Repo.insert()

    case article do
      {:ok, article} -> {:ok, article |> Repo.preload([:author, :tag_list, :favourited_by])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{source: %Article{}}

  """
  def change_article(%Article{} = article) do
    Article.changeset(article, %{})
  end

  def articles_with_is_favourited_flag(articles, target_user) do
    articles
    |> Enum.map(fn article ->
      is_favourited =
        article.favourited_by
        |> Enum.map(fn user -> user.id end)
        |> Enum.member?(target_user.id)

      Map.put(article, :is_favourited, is_favourited)
    end)
  end

  def article_with_is_favourited_flag(article, target_user) do
    is_favourited =
      article.favourited_by
      |> Enum.map(fn user -> user.id end)
      |> Enum.member?(target_user.id)

    Map.put(article, :is_favourited, is_favourited)
  end

  def create_favourite(attr \\ %{}) do
    %Favourite{}
    |> Favourite.changeset(attr)
    |> Repo.insert()
  end

  def delete_favourite(favourite) do
    Repo.delete(favourite)
  end

  def get_favourite_by_article_id_and_user_id(article_id, user_id) do
    query = from f in Favourite
    Repo.get_by(query, %{article_id: article_id, user_id: user_id})
  end
end
