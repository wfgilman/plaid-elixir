use Mix.Config

# Test keys
config :plaid, client_id: "test_id"
config :plaid, secret: "test_secret"
config :plaid, root_uri: "https://tartan.plaid.com/"
config :plaid, httpoison_options: [timeout: 10000, recv_timeout: 10000]

config :exvcr, [
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  custom_cassette_library_dir: "fixture/custom_cassettes",
  filter_sensitive_data: [
    [pattern: "<PASSWORD>.+</PASSWORD>", placeholder: "PASSWORD_PLACEHOLDER"]
  ],
  filter_url_params: false,
  response_headers_blacklist: []
]
