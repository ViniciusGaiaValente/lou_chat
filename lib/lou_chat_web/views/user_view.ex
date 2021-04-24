defmodule LouChatWeb.UserView do
  use LouChatWeb, :view
  alias LouChatWeb.UserView
  alias LouChatWeb.LobbyView

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    if (is_list(user.lobbies)) do
      %{
        name: user.name,
        email: user.email,
        lobbies: render_many(user.lobbies, LobbyView, "listed_lobby.json")
      }
    else
      %{
        name: user.name,
        email: user.email
      }
    end
  end

  def render("listed_user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end

  def render("create_account_response.json", %{user: user, token: token}) do
    %{
      token: token,
      user: %{
        name: user.name,
        email: user.email
      }
    }
  end
end
