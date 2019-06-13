defmodule ExRealworld.Contents.User do
  import Ecto.Changeset

  alias ExRealworld.Contents.Favourite

  use Ecto.Schema
  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :string
    field :username, :string

    has_many :favourites, Favourite

    timestamps()
  end

end
