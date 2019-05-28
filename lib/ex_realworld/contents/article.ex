defmodule ExRealworld.Contents.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :body, :string
    field :description, :string
    field :favourites_count, :integer
    field :slug, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body])
    |> validate_required([:title, :description, :body])
    |> slugify
    |> unique_constraint(:slug)
  end

  defp slugify(changeset) do
    title = changeset
      |> get_change(:title)
      |> String.downcase
      |> String.replace(" ", "_")
      |> String.replace(~r/\W/, "")
    Ecto.Changeset.put_change(changeset, :slug, title)
  end
end
