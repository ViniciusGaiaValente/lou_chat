defmodule LouChat.Auth.Guardian do
  use Guardian, otp_app: :lou_chat

  alias LouChat.Accounts

  def subject_for_token(resource, _claims) do
    sub = to_string(resource)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    {:ok,  id}
  end

  def authenticate(email, password) do
    case Accounts.authenticate_user(email, password) do
      { :error, message } -> { :error, message }
      user -> create_token(user)
    end
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user.id)
    {:ok, token}
  end
end
