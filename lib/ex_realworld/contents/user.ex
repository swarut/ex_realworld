defmodule ExRealworld.Contents.User do
  alias ExRealworld.Contents.Favourite

  use Ecto.Schema

  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :string
    field :username, :string

    # Just for testing purpose.
    field :token, :string

    has_many :favourites, Favourite

    timestamps()
  end
end
