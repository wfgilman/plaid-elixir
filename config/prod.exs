use Mix.Config

config :plaid,
  root_uri: "https://production.plaid.com/",
  client_id: "***REMOVED***",
  secret: "***REMOVED***",
  public_key: "***REMOVED***",
  httpoison_options: [timeout: 10_000, recv_timeout: 30_000]
