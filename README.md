# Plaid

[![Build Status](https://travis-ci.org/wfgilman/plaid-elixir.svg?branch=master)](https://travis-ci.org/wfgilman/plaid-elixir)
[![Coverage Status](https://coveralls.io/repos/github/wfgilman/plaid-elixir/badge.svg?branch=master)](https://coveralls.io/github/wfgilman/plaid-elixir?branch=master)
[![Module Version](https://img.shields.io/hexpm/v/plaid_elixir.svg)](https://hex.pm/packages/plaid_elixir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/plaid_elixir/)
[![Total Download](https://img.shields.io/hexpm/dt/plaid_elixir.svg)](https://hex.pm/packages/plaid_elixir)
[![License](https://img.shields.io/hexpm/l/plaid_elixir.svg)](https://github.com/wfgilman/plaid-elixir/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/wfgilman/plaid-elixir.svg)](https://github.com/wfgilman/plaid-elixir/commits/master)

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
  [
    {:plaid, "~> 2.0", hex: :plaid_elixir}
  ]
end
```

## Configuration

All calls to Plaid require your client id and secret. Public keys are deprecated as of version `2.4`.
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

As of version `2.5` you can pass HTTPoison options to the configuration at runtime. This can be
useful if you'd like to extend the `recv_timeout` parameter for certain calls to Plaid.

```elixir
Plaid.Transactions.get(%{access_token: "my-token"}, %{httpoison_options: [recv_timeout: 10_000]})
```

## Obtaining Access Tokens

Access tokens are required for almost all calls to Plaid. However, they can only be obtained
using [Plaid Link](https://plaid.com/docs/link/transition-guide/#creating-items-with-link).

Call the `/link` endpoint to create a link token that you'll use to initialize Plaid Link.
Once a user successfully connects to his institution using Plaid Link, a
public token is returned to the client. This single-use public token can be exchanged
for an access token and item id (both of which should be stored) using
`Plaid.Item.exchange_public_token/1`.

Consult Plaid's documentation for additional detail on this process.

## Metrics
This library emits [telemetry](https://github.com/beam-telemetry/telemetry) that you can use to get insight into communication
between your system and Plaid service. Emitted events are designed to be similar to the ones Phoenix emits. Those are the following:
* `[:plaid, :request, :start]` with `:system_time` measurement - signifies the moment request is being initiated
* `[:plaid, :request, :stop]` with `:duration` measurement - emitted after request has been finished
* `[:plaid, :request, :exception]` with `:duration` measurement - emitted in case there's an exception while making a request

Metadata attached (if applicable to event type) are as follows:
* `:method`, `:path`, `:status` - HTTP information on the request.
* `:u` - unit in which time is reported. Only value is `:native`.
* `:exception` - The exception that was thrown during making the request.
* `:result` - If no exception, contains either `{:ok, %HTTPoison.Response{}}` or `{:error, reason}`

All times are in :native unit.

## Compatibility

As of version `1.2`, this library natively supports serialization of its structs using `Jason` for compatibility with Phoenix.

## Tests and Style

This library uses [bypass](https://github.com/PSPDFKit-labs/bypass) to simulate HTTP responses from Plaid.

It uses Elixir's native formatter as of `1.3.2` and Credo.

## Copyright and License

Copyright (c) 2016 Will Gilman

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
