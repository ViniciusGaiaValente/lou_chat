defmodule LouChatWeb.SignedUserPlug do
  use LouChatWeb, :controller

  alias LouChat.Accounts

  def init(_params) do

  end

  def call(%{ private: %{ guardian_default_resource: user_id } } = conn, _params) do
    case Accounts.get_user_by_id(user_id) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "This user does not exist anymore, please sign in again."})
        |> halt()
      user ->
        conn
        |> assign(:signed_user, user)
    end
  end
end
