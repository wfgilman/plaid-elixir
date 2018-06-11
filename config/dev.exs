use Mix.Config

config :plaid,
  root_uri: "https://sandbox.plaid.com/",
  client_id: "***REMOVED***",
  secret: "***REMOVED***",
  public_key: "***REMOVED***",
  httpoison_options: [timeout: 10000, recv_timeout: 10000]
