use Mix.Config

config :plaid,
  client: PlaidMock,
  client_id: "test_id",
  secret: "test_secret",
  public_key: nil,
  root_uri: "http://localhost:4000/"
