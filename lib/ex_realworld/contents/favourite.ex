defmodule ExRealworld.Contents.Favourite do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.User

  schema "favourites" do
    belongs_to :user, User
    belongs_to :article, Article

    timestamps()
  end

  @doc false
  def changeset(favourite, attrs) do
    favourite
    |> cast(attrs, [:user_id, :article_id])
    |> validate_required([])
  end
end
