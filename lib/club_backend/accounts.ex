defmodule ClubBackend.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ClubBackend.Repo

  alias ClubBackend.Accounts.User

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

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
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
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

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
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user_by_username(username) do
    case Repo.get_by(User, username: username) do
      nil -> {:error, :no_user_by_username}
      user -> {:ok, user}
    end
  end

  def verify_password?(%User{} = user, password) do
    Argon2.verify_pass(password, user.password_hash)
  end

  @spec login(String.t(), String.t()) ::
          {:error, :invalid_username_or_pass} | {:ok, binary} | {:error, :unknown}
  def login(username, password) do
    with {:ok, user} <- get_user_by_username(username),
         true <- verify_password?(user, password),
         {:ok, token, _claims} <- ClubBackend.Guardian.encode_and_sign(user, %{}, auth_time: true) do
      {:ok, token}
    else
      false -> {:error, :invalid_username_or_pass}
      {:error, _changeset} -> {:error, :invalid_username_or_pass}
      _ -> {:error, :unknown}
    end
  end

  def register(username, password) do
    with {:ok, user} <- create_user(%{username: username, password: password}),
         {:ok, token, _claims} <- ClubBackend.Guardian.encode_and_sign(user, %{}, auth_time: true) do
      {:ok, token}
    else
      {:error, m} -> {:error, m}
    end
  end
end
