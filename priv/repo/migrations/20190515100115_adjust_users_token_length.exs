defmodule ExRealworld.Repo.Migrations.AdjustUsersTokenLength do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :token, :string, size: 500
    end
  end
end
