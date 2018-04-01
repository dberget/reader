# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :random_reader,
  ecto_repos: [RandomReader.Repo]

config :random_reader, RandomReader.Mailer,
  adapter: Bamboo.LocalAdapter

# Configures the endpoint
config :random_reader, RandomReader.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kLl2BC6iX5+NYvrcoroI+C13KXEoamfG3e30RX4vYCRyYcRMxuvlXv8Jav+4XzOP",
  render_errors: [view: RandomReader.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RandomReader.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
