defmodule ExRealworld.Contents.User do
  import Ecto.Changeset

  use Ecto.Schema
  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :string
    field :username, :string

    timestamps()
  end

end
