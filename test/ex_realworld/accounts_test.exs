defmodule ExRealworld.AccountsTest do
  use ExRealworld.DataCase

  alias ExRealworld.Accounts
  alias ExRealworld.Accounts.User

  describe "users" do
    @valid_attrs %{
      bio: "some bio",
      email: "some email",
      image: "some image",
      token: "some token",
      username: "some username",
      password: "password"
    }
    @update_attrs %{
      bio: "some updated bio",
      email: "some updated email",
      image: "some updated image",
      token: "some updated token",
      username: "some updated username",
      password: "password"
    }
    @invalid_attrs %{bio: nil, email: nil, image: nil, token: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.bio == "some bio"
      assert user.email == "some email"
      assert user.image == "some image"
      assert user.username == "some username"
      assert String.length(user.token) > 0
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with non-unique email returns error changeset" do
      Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.bio == "some updated bio"
      assert user.email == "some updated email"
      assert user.image == "some updated image"
      assert user.token == "some updated token"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authentication" do
    test "authenticate_with_email_and_token returns user if valid" do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      assert {:ok, %User{} = user} =
               Accounts.authenticate_with_email_and_token(user.email, user.token)
    end

    test "authenticate_with_email_and_token returns error if user not found" do
      assert {:error, :user_not_found} = Accounts.authenticate_with_email_and_token("xxxx", "yyy")
    end

    test "authenticate_with_email_and_token returns error if token was invalid" do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      assert {:error, :invalid_token} =
               Accounts.authenticate_with_email_and_token(user.email, "randomtoken")
    end

    test "authenticate_with_email_and_password returns user if valid" do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      assert {:ok, user} =
               Accounts.authenticate_with_email_and_password(user.email, @valid_attrs.password)
    end

    test "authenticate_with_email_and_password returns error if password was invalid" do
      {:ok, user} = Accounts.create_user(@valid_attrs)

      assert {:error, "invalid password"} =
               Accounts.authenticate_with_email_and_password(user.email, "1123")
    end
  end
end
