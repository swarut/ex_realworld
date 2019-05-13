defmodule ExRealworld.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :token, :string
      add :bio, :string
      add :image, :string

      timestamps()
    end

  end
end
