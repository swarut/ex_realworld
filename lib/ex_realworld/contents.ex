defmodule ExRealworld.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias ExRealworld.Repo

  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.Favourite
  alias ExRealworld.Contents.User

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
  def list_recent_articles(tag, limit, offset) do
    limit = limit || @max_recent_articles

    query = (from a in Article)
    |> Article.with_tag(tag)
    |> Article.recent
    |> Article.limit(limit)
    |> Article.offset(offset)

    # TODO: Investigate more why the below code doesn't work.
    # Repo.all(query, preload: :author)
    Repo.all(query) |> Repo.preload([:author, :tag_list, :favourite_by])
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
  def get_article!(id), do: Repo.get!(Article, id) |> Repo.preload([:author, :tag_list, :favourite_by])

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
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

  def article_is_favourited_by?(%Article{} = article, %User{} = user) do
    article_is_favourited_by?(article.id, user.id)
  end
  def article_is_favourited_by?(article_id, user_id) when is_number(article_id) and is_number(user_id) do
    case Repo.get_by(Favourite, [article_id: article_id, user_id: user_id]) do
      %Favourite{} -> true
      [] -> false
    end
  end

end
