# Plaid

An Elixir library for working with Plaid.

Plaid products supported by this library:

* [Exchange Token](https://plaid.com/docs/quickstart/#-exchange_token-endpoint)
* [Connect](https://plaid.com/docs/api/#connect)
* ~~Auth~~
* ~~Info~~
* ~~Balance~~
* ~~Risk~~
* ~~Income~~
* [Institutions](https://plaid.com/docs/api/#institutions)
* [Long Tail Institutions](https://plaid.com/docs/api/#long-tail-institutions)
* [Categories](https://plaid.com/docs/api/#categories)

Documentation is available on [Hex](https://hexdocs.pm/plaid_elixir).

The architecture of this product is largely inspired by Rob Conery's [stripity-stripe](https://github.com/robconery/stripity-stripe) - it's an awesome project.

## Installation

Add to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:plaid, "~> 0.1.0"}]
end
```

Add to your application:

```elixir
def application do
  [applications: [:plaid]]
end
```

## Configuration

This library requires the following configurations to be added to `config.exs`.
These values are obtained by registering with [Plaid](https://dashboard.plaid.com/signup/) for developer keys
or using the publicly available ones: `CLIENT_ID: "test_id"` and `SECRET: "test_secret"`.
```elixir
use Mix.Config

config :plaid, client_id: "YOUR_CLIENT_ID"
config :plaid, client_id: "YOUR_SECRET"
config :plaid, root_uri: "https://tartan.plaid.com/"
```
Developer keys can also be set in the System environment, although the application will
look first to `config.exs`.
```elixir
$export PLAID_CLIENT_ID="YOUR_CLIENT_ID"
$export PLAID_SECRET="YOUR_SECRET"
$iex -S mix
```

Default HTTPoison options can be configured here as well. See [HTTPoison docs](https://github.com/edgurgel/httpoison) for more detail.
```elixir
config :plaid, httpoison_options: [timeout: 10000, recv_timeout: 10000]
```

## Testing

In progress; testing is being added.

## The API Library

The library is structured by Plaid product. Each product corresponds to a module.
Each function in the module performs a specific action available in the product.

For example:

* Token
 * [Exchange Token](https://plaid.com/docs/quickstart/#-exchange_token-endpoint): `Plaid.Token.exchange/2`

* Connect
 * [Add Connect User](https://plaid.com/docs/api/#add-connect-user): `Plaid.Connect.add/2`
 * [Connect MFA](https://plaid.com/docs/api/#connect-mfa): `Plaid.Connect.mfa/2`
 * [Get Transactions](https://plaid.com/docs/api/#get-transactions): `Plaid.Connect.get/2`
 * [Update Connect User](https://plaid.com/docs/api/#update-connect-user): `Plaid.Connect.update/2`
 * [Delete Connect User](https://plaid.com/docs/api/#delete-connect-user): `Plaid.Connect.delete/2`

The response from Plaid is highly determined by the parameters submitted. Please read
the [Plaid API documentation](https://plaid.com/docs/api) and Hex docs closely.
All parameters are submitted as maps in this library.

Plaid requires credentials to be submitted with each call to their API.
For the endpoints requiring authentication, functions can be called using the
default credentials provided in `config.exs` or exported to `System.env`,
or supplied to the function directly. Each function in the API modules has an
arity of 1 and 2 to accommodate this.

For example, to add a new Plaid Connect user using default credentials:
```elixir
iex> params = %{username: "plaid_test", password: "plaid_good", type: "wells",
iex>            options: %{login_only: true}}
iex> {:ok, _struct} = Plaid.Connect.add(params)
```
...and to add using supplied credentials:
```elixir
iex> params = %{username: "plaid_test", password: "plaid_good", type: "wells",
iex>            options: %{login_only: true}}
iex> cred = %{client_id: "test_id", secret: "test_secret"}
iex> {:ok, _struct} = Plaid.Connect.add(params, cred)
```

All API functions return in the format of `{:ok, _}` or `{:error, _}`.

### Plaid Data Structures

Plaid responses are in JSON format. Responses are explicitly defined as structs
in this library for consistency and to avoid issues with dynamically converting
keys to atoms.

Modules related to modeling the JSON data structures are in the `/schemas` folder
in the application with the exception of the Categories and Institutions products.

## Contributions

I focused on the Plaid products I need, so several are undeveloped and I don't plan
on getting to them anytime soon, Therefore, contributions are welcome! I'm new to
Elixir and GitHub overall so helpful suggestions are always appreciated.
