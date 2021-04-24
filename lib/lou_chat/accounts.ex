defmodule LouChat.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias LouChat.Repo

  alias LouChat.Accounts.User

  def create_user(attrs \\ %{}) do
    result =
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()

    case result do
      { :ok, user } ->
        {
          :ok,
          user
          |> Map.delete(:password)
          |> Map.delete(:password_hash)
        }
      _ -> result
    end
  end

  def get_user_by_id(id) do
    case Repo.get(User, id) do
      nil -> nil
      user -> user
    end
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
    nil -> nil
    user ->
      user
      |> Repo.preload(:lobbies)
      |> Map.delete(:password_hash)
      |> Map.delete(:id)
    end
  end

  def get_user_by_name(name) do
    case Repo.get_by(User, name: name) do
    nil -> nil
    user ->
      user
      |> Repo.preload(:lobbies)
      |> Map.delete(:password_hash)
      |> Map.delete(:id)
      |> IO.inspect()
    end
  end

  def authenticate_user(email, password) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, "User not found"}
      user ->
        if validate_password(password, user.password_hash) do
          user
        else
          {:error, "Wrong password"}
        end
    end
  end

  def validate_password(password, password_hash) do
    Bcrypt.verify_pass(password, password_hash)
  end
end
