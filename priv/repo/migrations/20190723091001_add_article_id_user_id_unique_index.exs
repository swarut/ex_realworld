defmodule ExRealworld.Repo.Migrations.AddArticleIdUserIdUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:favourites, [:article_id, :user_id])
  end
end
