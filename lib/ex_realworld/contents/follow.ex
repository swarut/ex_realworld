defmodule ExRealworld.Contents.Follow do
  use Ecto.Schema

  alias ExRealworld.Contents.User

  schema "follows" do
    belongs_to(:follower, User)
    belongs_to(:followed, User)

    timestamps()
  end
end
