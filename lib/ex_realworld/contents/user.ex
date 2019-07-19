defmodule ExRealworld.Contents.User do
  alias ExRealworld.Contents.Favourite
  alias ExRealworld.Contents.User
  alias ExRealworld.Contents.Follow

  use Ecto.Schema

  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :string
    field :username, :string

    # Just for testing purpose.
    field :token, :string

    has_many :favourites, Favourite

    many_to_many(:followed, User,
      join_through: Follow,
      join_keys: [follower_id: :id, followed_id: :id]
    )

    many_to_many(:followers, User,
      join_through: Follow,
      join_keys: [followed_id: :id, follower_id: :id]
    )

    timestamps()
  end
end
