defmodule LouChatWeb.UserController do
  use LouChatWeb, :controller

  alias LouChat.Accounts
  alias LouChat.Accounts.User
  alias LouChat.Auth.Guardian

  action_fallback LouChatWeb.FallbackController

  def create(conn, user_params \\ %{}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
      { :ok, token, _claims } <- Guardian.encode_and_sign(user.id) do
      conn
      |> put_status(:created)
      |> render("create_account_response.json", %{user: user, token: token})
    end
  end

  def show(conn, %{"name" => name}) do
    user = Accounts.get_user_by_name(name)
    render(conn, "show.json", user: user)
  end

  def login(conn, %{ "email" => email, "password" => password }) do
    case Guardian.authenticate(email, password) do
      { :error, reason } ->
        conn
        |> put_status(:unauthorized)
        |> json(%{ error: reason })
        |> halt()
      { :ok, token } ->
        conn
        |> put_status(:ok)
        |> json(%{ token: token })
    end
  end

  def login(conn, _) do
    conn
    |> put_status(:bad_request)
    |> json(%{ error: "In order to login you need to provide a email and password" })
    |> halt()
  end
end
