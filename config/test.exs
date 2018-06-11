use Mix.Config

config :plaid,
  root_uri: "https://sandbox.plaid.com/",
  client_id: "test_id",
  secret: "test_secret",
  public_key: System.get_env("PLAID_PUBLIC_KEY"),
  httpoison_options: [timeout: 10000, recv_timeout: 10000]
