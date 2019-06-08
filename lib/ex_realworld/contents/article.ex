defmodule ExRealworld.Contents.Article do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias ExRealworld.Contents.Article

  schema "articles" do
    field :body, :string
    field :description, :string
    field :favourites_count, :integer
    field :slug, :string
    field :title, :string
    belongs_to :author, ExRealworld.Accounts.User, foreign_key: :user_id

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
    # query |> limit: ^lim
  end

  def recent(query) do
    query |> order_by: [desc: :id]
  end

  def for_article() do
    from a in Articles
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
