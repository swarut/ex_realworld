defmodule ExRealworld.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :string
    field :token, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :token, :bio, :image])
    |> validate_required([:email, :username, :token, :bio, :image])
  end
end
