defmodule ExRealworld.Contents.ArticleTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.Tag

  schema "articles_tags" do
    belongs_to(:article, Article)
    belongs_to(:tag, Tag)

    timestamps()
  end

  @doc false
  def changeset(article_tag, attrs) do
    article_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
