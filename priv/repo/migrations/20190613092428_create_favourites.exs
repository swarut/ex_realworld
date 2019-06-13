defmodule ExRealworld.Repo.Migrations.CreateFavourites do
  use Ecto.Migration

  def change do
    create table(:favourites) do
      add :user_id, references(:users, on_delete: :nothing)
      add :article_id, references(:articles, on_delete: :nothing)

      timestamps()
    end

    create index(:favourites, [:user_id])
    create index(:favourites, [:article_id])
  end
end
