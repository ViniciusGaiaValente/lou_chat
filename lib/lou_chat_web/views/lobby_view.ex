defmodule LouChatWeb.LobbyView do
  use LouChatWeb, :view
  alias LouChatWeb.LobbyView
  alias LouChatWeb.UserView

  def render("index.json", %{lobbies: lobbies}) do
    render_many(lobbies, LobbyView, "lobby.json")
  end

  def render("show.json", %{lobby: lobby}) do
    render_one(lobby, LobbyView, "lobby.json")
  end

  def render("lobby.json", %{lobby: lobby}) do
    %{
      name: lobby.name,
      description: lobby.description,
      public: lobby.public,
      owner: render_one(lobby.owner, UserView, "listed_user.json")
    }
  end

  def render("listed_lobby.json", %{lobby: lobby}) do
    %{
      id: lobby.id,
      name: lobby.name,
      description: lobby.description,
      public: lobby.public
    }
  end
end
