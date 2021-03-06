# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :kompax, Kompax.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),#remove this line or not? https://gist.github.com/chrismccord/29100e16d3990469c47f851e3142f766
  secret_key_base: "Be1gLTfquJF3xluivT0vuhhe1UpjsLo0w4UxdpnaaUhqvRkIFBkgU36csFeSNhRh",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Kompax.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :kompax, ecto_repos: [Kompax.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine
