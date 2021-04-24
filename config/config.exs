# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lou_chat,
  ecto_repos: [LouChat.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :lou_chat, LouChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uorfTL6wcrOS2jfojDLe27B0BjzNJ64dodbjVKsOlrj8hL0ucelK/7TvCt62Phr2",
  render_errors: [view: LouChatWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: LouChat.PubSub,
  live_view: [signing_salt: "Tqnhsjm/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :lou_chat, LouChat.Auth.Guardian,
  issuer: "lou_chat",
  secret_key: "xbF6tb90UzhdQPzA76BqZ1zDcj05HXCdAwsMrY2BVP2LPuNapXZtucJyhPLiEybp"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
