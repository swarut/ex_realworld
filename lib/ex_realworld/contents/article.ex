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
    |> cast(attrs, [:title, :slug, :description, :body, :favourites_count])
    |> validate_required([:title, :slug, :description, :body, :favourites_count])
    |> unique_constraint(:slug)
  end
end
