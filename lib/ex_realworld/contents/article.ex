defmodule ExRealworld.Contents.Article do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias ExRealworld.Contents.ArticleTag
  alias ExRealworld.Contents.Tag

  schema "articles" do
    field :body, :string
    field :description, :string
    field :favourites_count, :integer
    field :slug, :string
    field :title, :string
    belongs_to :author, ExRealworld.Accounts.User, foreign_key: :user_id
    many_to_many(:tag_list, Tag, join_through: ArticleTag)

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

  def limit(query, lim) do
    from a in query, limit: ^lim
  end

  def recent(query) do
    from a in query, order_by: [desc: :id]
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
