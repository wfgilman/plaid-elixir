# Parameters

## Payload

This library opts to accept function arguments as a single map containing multiple parameters
rather than each parameter as a function argument.

For example, when fetching Plaid transactions, you would construct the following
map which you pass to `Plaid.Transactions.get/1`:
```
params = %{
  access_token: "access-env-identifier",
  start_date: "2017-01-01",
  end_date: "2017-03-31",
  options: %{
    count: 20,
    offset: 0
  }
}

{:ok, _} = Plaid.Transactions.get(params)
```

This is opposed to passing in each payload item as a separate function argument:
```
{:ok, _} = Plaid.Transactions.get("access-env-identifier", "2017-01-01", "2017-03-31", %{})
```

There are pros and cons of this approach.

#### Pros

- Library is flexible. No update is needed if Plaid adds another item to the request
payload (such as a date filter in the `options` key).
- Library is simpler; less code to maintain.
- Separating the parameter construction from the function call allows you to do
convenient things, such as paginating requests more clearly.

```
number_of_transactions
|> chunk_into_pages()
|> Enum.map(&construct_params/1)
|> Enum.map(&Plaid.Transactions.get/1)
```

#### Cons

- Business logic burden falls back on the user to know what the payload requests must be.
- More difficult to validate request payloads.

## Credentials

By default, all requests use the Plaid credentials set in your configuration.
However, all functions accept the credentials as an argument which will override
the default credentials set in your configuration.
