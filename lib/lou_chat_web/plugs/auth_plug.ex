defmodule LouChatWeb.AuthPlug do
  use Guardian.Plug.Pipeline, otp_app: :lou_chat,
    module: LouChat.Auth.Guardian,
    error_handler: LouChat.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
