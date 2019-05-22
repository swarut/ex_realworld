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
    |> unique_constraint(:email)
    |> encrypt_password
    |> strip_password
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :token, :bio, :image])
    |> validate_email_not_nil
  end

  defp encrypt_password(changeset = %Ecto.Changeset{valid?: true, changes: %{password: password}}) do
    changeset
    |> put_change(:encrypted_password, Pbkdf2.hash_pwd_salt(password))
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

  defp validate_email_not_nil(changeset = %Ecto.Changeset{valid?: true, changes: %{email: nil}}) do
    add_error(changeset, :email, "can not be null")
  end
  defp validate_email_not_nil(changeset) do
    changeset
  end
end
