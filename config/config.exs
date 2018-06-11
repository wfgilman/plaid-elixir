use Mix.Config

config :plaid, ecto_repos: []

import_config "#{Mix.env}.exs"
