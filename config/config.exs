# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :aspekt,
  ecto_repos: [Aspekt.Repo]

# Configures the endpoint
config :aspekt, AspektWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/P0F6zOl642C+d1S7Qss1HkP0EoDYM1HgKYGvX/E1DQc99B4FJnJId2cScpGKMY7",
  render_errors: [view: AspektWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Aspekt.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Key length is 128, 192 or 256 bits
config :aspekt, Aspekt.AES,
  keys: %{
    <<1>> => "B658F2C1932E3ECC02182AE49A8CCE07" |> Base.decode16,
    <<2>> => "2B07446BE68F6E5DE38B905BB54B99CF" |> Base.decode16
  },
  default_key_id: <<1>> # The ID of the key we want to use

config :aspekt, Aspect.Accounts.Password,
  algorithm: :bcrypt

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
