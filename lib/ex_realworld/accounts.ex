defmodule ExRealworld.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ExRealworld.Repo

  alias ExRealworld.Accounts.User
  alias ExRealworld.Accounts.Follow

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_last_user, do: Repo.one(from u in User, order_by: [desc: u.id], limit: 1)

  def get_user_by(clause), do: Repo.get_by(User, clause)
  def get_user_by!(clause), do: Repo.get_by!(User, clause)

  def authenticate_with_email_and_token(email, token) do
    case get_user_by(email: email) do
      nil ->
        {:error, :user_not_found}

      user ->
        t = user.token

        case token do
          ^t -> {:ok, user}
          _ -> {:error, :invalid_token}
        end
    end
  end

  def authenticate_with_email_and_password(email, password) do
    with user <- get_user_by(email: email) do
      Pbkdf2.check_pass(user, password)
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    with {:ok, user} <- %User{} |> User.changeset(attrs) |> Repo.insert() do
      {:ok, token, _claims} =
        ExRealworldWeb.UserToken.encode_and_sign(%{id: user.id}, %{email: user.email})

      update_user(user, %{token: token})
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Follow a specific user.

  ## Examples

      iex> follow_user(user_who_follows, user_who_will_be_followed)
      %User{id: 1, following: true}

  """
  def follow_user(user_who_follows, user_who_will_be_followed)
      when is_map(user_who_follows) and is_map(user_who_will_be_followed) do
    follow_user(user_who_follows.id, user_who_will_be_followed.id)
  end

  def follow_user(user_who_follows_id, user_who_will_be_followed_id)
      when is_number(user_who_follows_id) and is_number(user_who_will_be_followed_id) do
    with {:ok, follow_record} <-
           %Follow{}
           |> Follow.changeset(%{
             follower_id: user_who_follows_id,
             followed_id: user_who_will_be_followed_id
           })
           |> Repo.insert() do
      get_user!(follow_record.followed_id)
    end
  end

  @doc """
  Unfollow a specific user.

  ## Examples

      iex> unfollow_user(user_who_follows, user_who_will_be_unfollowed)
      %User{id: 1, following: false}

  """
  def unfollow_user(user_who_follows, user_who_will_be_unfollowed)
      when is_map(user_who_follows) and is_map(user_who_will_be_unfollowed) do
    unfollow_user(user_who_follows.id, user_who_will_be_unfollowed.id)
  end

  def unfollow_user(user_who_follows_id, user_who_will_be_unfollowed_id)
      when is_number(user_who_follows_id) and is_number(user_who_will_be_unfollowed_id) do
    query = Follow.follow_record(user_who_follows_id, user_who_will_be_unfollowed_id)
    follow_record = Repo.get_by(query, %{})

    with {:ok, unfollowed_record} <-
           Repo.delete(follow_record) do
      get_user!(unfollowed_record.followed_id)
    end
  end

  @doc """
  Fill the target user record with the predicate indicating if the target user was followed by the user or not.

  # Examples

      iex> fill_follow_data(user_who_may_follow, user_who_may_be_followed)
      %User{id: 1, following: true}

  """
  def fill_follow_data(user_who_may_follow, user_who_may_be_followed) do
    Map.put(
      user_who_may_be_followed,
      :following,
      does_user_follows(user_who_may_follow.id, user_who_may_be_followed.id)
    )
  end

  @doc """
  Check whether the user follows the target user or not.

  # Examples

      iex> does_user_follows(user_who_may_follow, user_who_may_be_followed)
      true

  """
  def does_user_follows(user_who_may_follow_id, user_who_may_be_followed_id) do
    query =
      from f in Follow,
        where:
          f.follower_id == ^user_who_may_follow_id and
            f.followed_id == ^user_who_may_be_followed_id

    Repo.exists?(query)
  end
end
