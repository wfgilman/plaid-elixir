# Plaid

[![Build Status](https://travis-ci.org/wfgilman/plaid-elixir.svg?branch=master)](https://travis-ci.org/wfgilman/plaid-elixir)
[![Coverage Status](https://coveralls.io/repos/github/wfgilman/plaid-elixir/badge.svg?branch=master)](https://coveralls.io/github/wfgilman/plaid-elixir?branch=master)
[![Hex.pm Version](https://img.shields.io/hexpm/v/plaid_elixir.svg)](https://hex.pm/packages/plaid_elixir)
[![Hex.pm Download Total](https://img.shields.io/hexpm/dt/plaid_elixir.svg)](https://hex.pm/packages/plaid_elixir)

[Documentation](https://hexdocs.pm/plaid_elixir)

Elixir library for Plaid's V2 API.

Supported Plaid products:

- [x] Transactions
- [x] Auth
- [x] Identity
- [x] Balance
- [x] Income
- [ ] Assets
- [x] Investments

[Plaid Documentation](https://plaid.com/docs/api)

## Usage

Add to your dependencies in `mix.exs`. The hex specification is required.

```elixir
def deps do
  [{:plaid, "~> 1.9", hex: :plaid_elixir}]
end
```

## Configuration

All calls to Plaid require your client id and secret. Public keys are deprecated as of version `2.4` of the upstream project.
Add the following configuration to your project to set the values. This configuration is optional
as of version `1.6`, see below for a runtime configuration. The library will raise an
error if the relevant credentials are not provided either via `config.exs` or at runtime.

```elixir
config :plaid,
  root_uri: "https://development.plaid.com/",
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

## Runtime configuration

Alternatively, you can provide the configuration at runtime. The configuration passed
as a function argument will overwrite the configuration in `config.exs`, if one exists.

For example, if you want to hit a different URL when calling the `/accounts` endpoint, you could
pass in a configuration argument to `Plaid.Accounts.get/2`.

```elixir
Plaid.Accounts.get(%{access_token: "my-token"}, %{root_uri: "http://sandbox.plaid.com/", secret: "no-secrets"})
```

## Obtaining Access Tokens

Access tokens are required for almost all calls to Plaid. However, they can only be obtained
using [Plaid Link](https://plaid.com/docs/link/transition-guide/#creating-items-with-link).

Once a user successfully connects to his institution using Plaid Link, a
public token is returned to the client. This single-use public token can be exchanged
for an access token and item id (both of which should be stored) using
`Plaid.Item.exchange_public_token/1`.

Consult Plaid's documentation for additional detail on this process.

## Compatibility

As of version `1.2`, this library natively supports serialization of its structs using `Jason` for compatibility with Phoenix.

## Tests and Style

This library uses [bypass](https://github.com/PSPDFKit-labs/bypass) to simulate HTTP responses from Plaid.

It uses Elixir's native formatter as of `1.3.2`
