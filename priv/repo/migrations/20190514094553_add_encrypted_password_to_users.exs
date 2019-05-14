defmodule ExRealworld.Repo.Migrations.AddEncryptedPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :encrypted_password, :string
    end
  end
end
