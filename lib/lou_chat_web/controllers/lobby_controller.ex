defmodule LouChatWeb.LobbyController do
  use LouChatWeb, :controller

  alias LouChat.Chat
  alias LouChat.Chat.Lobby

  action_fallback LouChatWeb.FallbackController

  def index(conn, _params) do
    lobbies = Chat.list_lobbies()
    render(conn, "index.json", lobbies: lobbies)
  end

  def create(conn, lobby_params \\ %{}) do
    with {:ok, %Lobby{} = lobby} <-
      Chat.create_lobby(
        lobby_params
        |> Map.put("owner", conn.assigns.signed_user)
      ) do
      conn
      |> put_status(:created)
      |> render("show.json", lobby: lobby)
    end
  end

  def show(conn, %{"id" => id}) do
    lobby = Chat.get_lobby!(id)
    render(conn, "show.json", lobby: lobby)
  end
end
