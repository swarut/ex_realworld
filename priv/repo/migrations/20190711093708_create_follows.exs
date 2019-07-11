defmodule ExRealworld.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :follower_id, references(:users, on_delete: :nothing)
      add :followed_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:follows, [:follower_id])
    create index(:follows, [:followed_id])
  end
end
