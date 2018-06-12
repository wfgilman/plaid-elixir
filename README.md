# Plaid

[![Build Status](https://travis-ci.org/wfgilman/plaid-elixir.svg?branch=master)](https://travis-ci.org/wfgilman/plaid-elixir)
[![Hex.pm Version](https://img.shields.io/hexpm/v/plaid_elixir.svg)](https://hex.pm/packages/plaid_elixir)

Elixir library for Plaid's V2 API.

Supported Plaid products:
- [x] Transactions
- [x] Auth
- [ ] Identity
- [x] Balance
- [ ] Income
- [ ] Assets

## Usage

Add to your dependencies in `mix.exs`.

```elixir
def deps do
  [{:plaid, "~> 1.0"}]
end
```

## Configuration

The following variables must be set for Plaid to run outside of testing:
`client_id`, `secret` and `public_key`.

You can set these in the config files directly, or export them as environment
variables: `PLAID_CLIENT_ID`, `PLAID_SECRET`, `PLAID_PUBLIC_KEY`. If exported,
they will override the values in the config files.

## Tests and Style

Plaid uses [bypass](https://github.com/PSPDFKit-labs/bypass) to simulate HTTP responses from Plaid.

Run tests using `mix test`.

Before making pull requests, run the coverage and style checks.
```elixir
mix coveralls
mix credo
```

## Support

I shut down the company I was using this library in production for, so I've got
a little more time to make this a robust library. Hit me up with any bugs or
feature requests.
