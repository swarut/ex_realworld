defmodule ExRealworld.Contents.Article do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias ExRealworld.Contents.ArticleTag
  alias ExRealworld.Contents.Favourite
  alias ExRealworld.Contents.Tag
  alias ExRealworld.Contents.User
  alias ExRealworld.Contents.Follow

  schema "articles" do
    field :body, :string
    field :description, :string
    field :favourites_count, :integer
    field :slug, :string
    field :title, :string
    field :is_favourited, :boolean, virtual: true, default: false

    belongs_to :author, ExRealworld.Contents.User, foreign_key: :user_id
    many_to_many :favourited_by, User, join_through: Favourite, on_delete: :delete_all
    many_to_many :tag_list, Tag, join_through: ArticleTag, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body, :favourites_count, :user_id])
    |> validate_required([:title, :description, :body])
    |> slugify

    # |> unique_constraint(:slug)  # Removed as not required by spec.
  end

  def recent(query) do
    from a in query, order_by: [desc: :id]
  end

  def with_tag(query, nil), do: query

  def with_tag(query, tag) do
    from a in query, join: t in assoc(a, :tag_list), where: t.title == ^tag
  end

  def with_favourited_by(query, nil), do: query

  def with_favourited_by(query, author) do
    from a in query,
      join: f in assoc(a, :favourited_by),
      join: u in User,
      where: u.username == ^author
  end

  def from_followed_users_of_user(query, user_id) do
    from a in query,
      join: f in Follow,
      on: f.followed_id == a.user_id,
      where: f.follower_id == ^user_id
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
    title =
      title
      |> String.downcase()
      |> String.replace(" ", "-")

    Ecto.Changeset.put_change(changeset, :slug, title)
  end

  defp slugify(changeset) do
    changeset
  end
end
