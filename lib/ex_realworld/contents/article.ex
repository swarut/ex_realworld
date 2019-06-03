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
    |> cast(attrs, [:title, :description, :body, :favourites_count])
    |> validate_required([:title, :description, :body])
    |> slugify
    |> unique_constraint(:slug)
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
