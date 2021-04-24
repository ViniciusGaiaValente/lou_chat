defmodule LouChat.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias LouChat.Repo
  alias LouChat.Chat.Lobby

  def list_lobbies, do: Repo.all(Lobby) |> Repo.preload(:owner)

  def get_lobby!(id), do: Repo.get!(Lobby, id) |> Repo.preload(:owner)

  def get_lobby_by_name(name), do: Repo.get_by(Lobby, name: name)

  def create_lobby(attrs \\ %{}) do
    result =
      %Lobby{}
      |> Lobby.changeset(attrs)
      |> Repo.insert()

    case result do
      { :ok, lobby } ->
        {
          :ok,
          lobby
          |> Repo.preload(:owner)
          |> Map.delete(:password)
          |> Map.delete(:password_hash)
        }
      _ -> result
    end
  end
end
