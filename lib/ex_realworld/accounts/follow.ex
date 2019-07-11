defmodule ExRealworld.Accounts.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExRealworld.Accounts.User

  schema "follows" do
    belongs_to(:follower, User)
    belongs_to(:followed, User)

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([])
  end
end
