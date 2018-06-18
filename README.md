# Plaid

[![Build Status](https://travis-ci.org/wfgilman/plaid-elixir.svg?branch=master)](https://travis-ci.org/wfgilman/plaid-elixir)
[![Hex.pm Version](https://img.shields.io/hexpm/v/plaid_elixir.svg)](https://hex.pm/packages/plaid_elixir)

Elixir library for Plaid's V2 API.

Supported Plaid products:
- [x] Transactions
- [ ] Auth
- [ ] Identity
- [x] Balance
- [ ] Income
- [ ] Assets

[Plaid Documentation](https://plaid.com/docs/api)

## Usage

Add to your dependencies in `mix.exs`.

```elixir
def deps do
  [{:plaid, "~> 1.0"}]
end
```

## Configuration

All calls to Plaid require either your client id and secret, or public key. Add the
following configuration to your project to set the values.

```elixir
config :plaid,
  root_uri: "https://development.plaid.com/"
  client_id: "your_client_id",
  secret: "your_secret",
  public_key: "your_public_key",
  httpoison_options: [timeout: 10_000, recv_timeout: 30_000]
```

By default, `root_uri` is set by `mix` environment. You can override it in your config.
- `dev` - development.plaid.com
- `prod`- production.plaid.com

Finally, you can pass in custom configuration for [HTTPoison](https://github.com/edgurgel/httpoison). It's recommended you
extend the receive timeout for Plaid, especially for retrieving historical transactions.

## Tests and Style

This library uses [bypass](https://github.com/PSPDFKit-labs/bypass) to simulate HTTP responses from Plaid.
