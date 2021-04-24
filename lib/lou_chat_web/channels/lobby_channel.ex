defmodule LouChatWeb.LobbyChannel do
  use Phoenix.Channel
  require Logger

  alias LouChat.Chat

  def join("lobby:" <> name, %{"password" => password}, socket) do
    case Chat.get_lobby_by_name(name) do
      %{public: true} ->
        {:ok, socket}
      %{password_hash: password_hash} ->
        if validate_password(password, password_hash) do
          {:ok, socket}
        else
          {:error, "Wrong password"}
        end
      nil ->
        {:error, "Lobby not found"}
    end
  end

  def join("lobby:" <> name, _body, socket) do
    case Chat.get_lobby_by_name(name) do
      %{public: true} ->
        {:ok, socket}
      nil ->
        {:error, "Lobby not found"}
      _ ->
        {:error, "You need a password to connect to this lobby"}
    end
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  def handle_info(:ping, socket) do
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", %{"body" => body}, socket) do
    broadcast!(socket, "new:msg", %{body: body})
    {:noreply, socket}
  end

  defp validate_password(password, password_hash) do
    Bcrypt.verify_pass(password, password_hash)
  end
end
