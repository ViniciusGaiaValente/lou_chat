defmodule LouChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LouChat.Repo,
      # Start the Telemetry supervisor
      LouChatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LouChat.PubSub},
      # Start the Endpoint (http/https)
      LouChatWeb.Endpoint
      # Start a worker by calling: LouChat.Worker.start_link(arg)
      # {LouChat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LouChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LouChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
