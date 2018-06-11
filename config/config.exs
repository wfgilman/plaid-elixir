use Mix.Config

config :plaid,
  root_uri: "https://sandbox.plaid.com/",
  client_id: System.get_env("PLAID_CLIENT_ID") || "test_id",
  secret: System.get_env("PLAID_SECRET") || "test_secret",
  public_key: System.get_env("PLAID_PUBLIC_KEY") || "",
  httpoison_options: [timeout: 10_000, recv_timeout: 10_000]

import_config "#{Mix.env}.exs"
