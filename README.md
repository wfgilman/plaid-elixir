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
- [x] Assets
- [x] Investments

[Plaid Documentation](https://plaid.com/docs/api)

## Changes in 3.0

`3.0` replaces [HTTPoison](https://github.com/edgurgel/httpoison) with [Tesla](https://github.com/teamon/tesla)
behind the scenes to provide more flexibility around HTTP calls. Additionally, `3.0` refactors
the test suite, hard deprecates several functions, and fixes small bugs when decoding Plaid JSON
responses into internal data structures.

While these changes are primarily transparent, if you are considering upgrading to version `3.0`
it's recommended you review the full list of breaking changes in the changelog.

Big thanks to [yordis](https://github.com/yordis) for driving major improvements to `3.0`!

## Usage

Add to your dependencies in `mix.exs`. The hex specification is required.

```elixir
def deps do
  [
    {:plaid, "~> 3.0", hex: :plaid_elixir}
  ]
end
```

Call the library from your project and match on the responses, for example, from a
Phoenix controller.

```elixir
defmodule MyController do
  use Web, :controller

  def index(conn, _params) do
    token = ...

    case Plaid.Accounts.get(%{access_token: token}) do
      {:ok, %Plaid.Accounts{accounts: accts}} ->
        conn
        |> put_status(200)
        |> json(accts)
      {:error, %Plaid.Error{error_message: msg}} ->
        conn
        |> put_status(400)
        |> json(%{message: msg})
      {:error, reason} ->
        conn
        |> put_status(400)
        |> json(%{message: "Request failed, please try again."})
    end
  end
end
```

## Configuration

All calls to Plaid require your client id and secret. Add the following configuration
to your project to set the values. This configuration is optional, see below for a
runtime configuration. The library will raise an error if the relevant credentials
are not provided either via `config.exs` or at runtime.

```elixir
config :plaid,
  root_uri: "https://development.plaid.com/",
  client_id: "your_client_id",
  secret: "your_secret",
  adapter: Tesla.Adapter.Hackney, # optional
  middleware: [Tesla.Middleware.Logger], # optional
  http_options: [timeout: 10_000, recv_timeout: 30_000] # optional
```

By default, `root_uri` is set by `mix` environment. You can override it in your config.
* `dev` - https://development.plaid.com/
* `prod` - https://production.plaid.com/

Finally, you can specify your HTTP client of choice with `adapter` key. The adapter is passed to [Tesla](https://github.com/teamon/tesla) and [hackney](https://github.com/benoitc/hackney) is the default adapter if this
configuration is omitted.

The `http_options` key specifies the custom configuration for your HTTP client adapter. It's recommended you
extend the receive timeout for Plaid, especially for retrieving historical transactions. In the code
snippet above, `[timeout: 10_000, recv_timeout: 30_000]` are timeout options understood by hackney.

## Runtime configuration

Alternatively, you can provide the configuration at runtime. The configuration passed
as a function argument will overwrite the configuration in `config.exs`, if one exists.

For example, if you want to hit a different URL when calling the `/accounts` endpoint, you could
pass in a configuration argument to `Plaid.Accounts.get/2`.

```elixir
Plaid.Accounts.get(
  %{access_token: "my-token"},
  %{root_uri: "http://sandbox.plaid.com/", secret: "no-secrets"}
)
```

HTTP client options may also be passed to the configuration at runtime. This can be
useful if you'd like to extend the receive timeout for certain calls to Plaid.
HTTP client options will need to conform to the selected HTTP adapter.

```elixir
Plaid.Transactions.get(
  %{access_token: "my-token"},
  %{http_options: [recv_timeout: 10_000]}
)
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
* `[:tesla, :request, :start]` with `:system_time` measurement - signifies the moment request is being initiated
* `[:tesla, :request, :stop]` with `:duration` measurement - emitted after request has been finished
* `[:tesla, :request, :exception]` with `:duration` measurement - emitted in case there's an exception while making a request

Metadata attached (if applicable to event type) are as follows:
* `:env` - `Tesla.Env` containing information on the request, including `:method, :url, :status`
* `:service` - Included by default to distinguish events from other potential tesla middleware. Only value is `:plaid`
* `:u` - unit in which time is reported. Only value is `:native`.
* `:error` - The error returned when making the request.
* `:kind, :reason, :stacktrace` - Information about any exception raised during the request

Additionally, you can pass your custom metadata through the `config` parameter when calling a product endpoint.
Put it under `telemetry_metadata` and it will be merged to the event metadata.

All times are in `:native` unit. Telemetry instrumentation is implemented using [Tesla.Middleware](https://github.com/teamon/tesla#middleware).

#### Backward Compatibility

To continue receiving events in the format of the `2.5` version of this library,
add `Plaid.Telemetry` to the `middleware` in your config:
```elixir
config  :plaid
  middleware: [Plaid.Telemetry]
```

If you'd like to migrate to the telemetry events emitted in `3.0`, modify your event handler
to listen for `[:tesla, :request, :start]` instead of `[:plaid, :request, :start]`. In the
metadata, the fields in `2.5` map to the following in `3.0`:
* `:method` -> `Tesla.Env{:method}`
* `:path` -> `Tesla.Env[:url]`
* `:status` -> `Tesla.Env[:status]`
* `:result` -> `Tesla.Env`
* `:reason` -> `:error`
* `:exception` -> `:kind, :reason, :stacktrace`

## Custom Middleware

Using [Tesla](https://github.com/teamon/tesla) under the hood provides additional capabilities that can
be useful for communicating with Plaid, such as retry logic and logging, or emitting refined telemetry events.

By default this library uses the following middleware:
* `Tesla.Middleware.BaseUrl`
* `Tesla.Middleware.Headers`
* `Tesla.Middleware.JSON`
* `Plaid.Telemetry` (_custom implementation of_ `Tesla.Middleware.Telemetry`)

To include additional middleware, add either Tesla's supported middleware, or your own, to the `middleware` key
in `config.exs` or pass it via the `config` argument at runtime.

To write your own middleware, please see [Tesla's documentation](https://hexdocs.pm/tesla/Tesla.Middleware.html#module-writing-custom-middleware) or the [Wiki Cookbook on Github](https://github.com/teamon/tesla/wiki).

## Compatibility

This library natively supports serialization of its structs using `Jason` for compatibility with Phoenix.

## Tests and Style

This library tries to implement best practices for unit and integration testing and
version `3.0` implements major improvements.

Unit testing is done using [mox](https://github.com/dashbitco/mox) and follows the principals
outlined in the well-known article by José Valim linked in that repo.  Unit tests can
be run standalone using `ExUnit` tags.
```
mix test --only unit
```

Integration testing uses [bypass](https://github.com/PSPDFKit-labs/bypass) to simulate HTTP responses from Plaid.
Integration tests can also be run in isolation using tags.
```
mix test --only integration
```

Static analysis is performed using [dialyzer](https://github.com/jeremyjh/dialyxir).

Elixir's native formatter is used along with [credo](https://github.com/rrrene/credo)
for code analysis.

## Copyright and License

Copyright (c) 2016 Will Gilman

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
