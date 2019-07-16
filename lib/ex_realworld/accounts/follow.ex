defmodule ExRealworld.Accounts.Follow do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias ExRealworld.Accounts.User
  alias ExRealworld.Accounts.Follow

  schema "follows" do
    belongs_to(:follower, User)
    belongs_to(:followed, User)

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :followed_id])
    |> validate_required([:follower_id, :followed_id])
    |> unique_constraint(:follower_id, name: :follows_follower_id_followed_id_index)
  end

  def follow_record(follow_id, followed_id) do
    from f in Follow,
      where:
        f.follower_id == ^follow_id and
          f.followed_id == ^followed_id
  end
end
