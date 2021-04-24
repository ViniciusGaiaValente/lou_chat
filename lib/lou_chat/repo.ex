defmodule LouChat.Repo do
  use Ecto.Repo,
    otp_app: :lou_chat,
    adapter: Ecto.Adapters.Postgres
end
