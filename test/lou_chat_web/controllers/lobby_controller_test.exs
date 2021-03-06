defmodule LouChatWeb.LobbyControllerTest do
  use LouChatWeb.ConnCase

  alias LouChat.Chat
  alias LouChat.Chat.Lobby

  @create_attrs %{
    description: "some description",
    name: "some name",
    password_hash: "some password_hash",
    public: true
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    password_hash: "some updated password_hash",
    public: false
  }
  @invalid_attrs %{description: nil, name: nil, password_hash: nil, public: nil}

  def fixture(:lobby) do
    {:ok, lobby} = Chat.create_lobby(@create_attrs)
    lobby
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all lobbies", %{conn: conn} do
      conn = get(conn, Routes.lobby_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create lobby" do
    test "renders lobby when data is valid", %{conn: conn} do
      conn = post(conn, Routes.lobby_path(conn, :create), lobby: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.lobby_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name",
               "password_hash" => "some password_hash",
               "public" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.lobby_path(conn, :create), lobby: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update lobby" do
    setup [:create_lobby]

    test "renders lobby when data is valid", %{conn: conn, lobby: %Lobby{id: id} = lobby} do
      conn = put(conn, Routes.lobby_path(conn, :update, lobby), lobby: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.lobby_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name",
               "password_hash" => "some updated password_hash",
               "public" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, lobby: lobby} do
      conn = put(conn, Routes.lobby_path(conn, :update, lobby), lobby: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete lobby" do
    setup [:create_lobby]

    test "deletes chosen lobby", %{conn: conn, lobby: lobby} do
      conn = delete(conn, Routes.lobby_path(conn, :delete, lobby))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.lobby_path(conn, :show, lobby))
      end
    end
  end

  defp create_lobby(_) do
    lobby = fixture(:lobby)
    %{lobby: lobby}
  end
end
