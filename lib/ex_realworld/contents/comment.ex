defmodule ExRealworld.Contents.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExRealworld.Contents.Article
  alias ExRealworld.Contents.User

  schema "comments" do
    field :body, :string
    belongs_to :author, User, foreign_key: :user_id
    belongs_to :article, Article

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
  end
end
