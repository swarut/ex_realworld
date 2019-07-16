defmodule ExRealworld.Repo.Migrations.AddFollowIdFollowedIdUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:follows, [:follower_id, :followed_id])
  end
end
