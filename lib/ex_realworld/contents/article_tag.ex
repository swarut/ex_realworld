defmodule ExRealworld.Contents.ArticleTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.Tag

  schema "articles_tags" do
    field :article_id, :id
    field :tag_id, :id
    belongs_to(:articles, Article)
    belongs_to(:tags, Tag)

    timestamps()
  end

  @doc false
  def changeset(article_tag, attrs) do
    article_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
