# Plaid

Elixir library for Plaid.

## Installation

Plaid is an application within an umbrella application. It can be added as a
dependency as follows:

```elixir
def deps do
  [{:plaid, in_umbrella: true}]
end
```

## Configuration

The following environment variables must be set for Plaid to run outside of
testing: `PLAID_CLIENT_ID`, `PLAID_SECRET`, `PLAID_PUBLIC_KEY`.

## Tests and Style

Plaid uses [bypass](https://github.com/PSPDFKit-labs/bypass) to simulate HTTP responses from Plaid.

Run tests using `mix test`.

Before making pull requests, run the coverage, style and typespec checks.
```elixir
mix coveralls
mix credo
mix dialyzer
```
