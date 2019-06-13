defmodule ExRealworld.Contents.Article do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias ExRealworld.Contents.ArticleTag
  alias ExRealworld.Contents.Favourite
  alias ExRealworld.Contents.Tag

  schema "articles" do
    field :body, :string
    field :description, :string
    field :favourites_count, :integer
    field :slug, :string
    field :title, :string

    belongs_to :author, ExRealworld.Contents.User, foreign_key: :user_id
    has_many :favourites, Favourite
    many_to_many :tag_list, Tag, join_through: ArticleTag

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body, :favourites_count, :user_id])
    |> validate_required([:title, :description, :body])
    |> slugify
    |> unique_constraint(:slug)
  end

  def recent(query) do
    from a in query, order_by: [desc: :id]
  end

  def with_tag(query, nil), do: query
  def with_tag(query, tag) do
    from a in query, join: t in assoc(a, :tag_list), where: t.title == ^tag
  end

  def limit(query, lim) do
    from a in query, limit: ^lim
  end
  def limit(query), do: query

  def offset(query, nil), do: query
  def offset(query, off) do
    from a in query, offset: ^off
  end

  defp slugify(changeset = %Ecto.Changeset{valid?: true, changes: %{title: title}}) do
    title = title
      |> String.downcase
      |> String.replace(" ", "-")
    Ecto.Changeset.put_change(changeset, :slug, title)
  end
  defp slugify(changeset) do
    changeset
  end
end
