defmodule ExRealworld.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :slug, :string
      add :description, :string
      add :body, :text
      add :favourites_count, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:articles, [:slug])
    create index(:articles, [:user_id])
  end
end
