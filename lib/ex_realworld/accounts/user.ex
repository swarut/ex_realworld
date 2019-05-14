defmodule ExRealworld.Accounts.User do
  import Ecto.Changeset

  use Ecto.Schema
  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :string
    field :token, :string
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :token, :bio, :image, :password])
    |> validate_required([:email, :password])
    |> encrypt_password
    |> strip_password

  end

  defp encrypt_password(changeset = %Ecto.Changeset{valid?: true, changes: %{password: password}}) do
    changeset
    |> put_change(:encrypted_password, password)
  end
  defp encrypt_password(changeset) do
    changeset
  end

  defp strip_password(changeset = %Ecto.Changeset{valid?: true, changes: %{password: _password}}) do
    changeset
    |> put_change(:password, nil)
  end
  defp strip_password(changeset) do
    changeset
  end

end
