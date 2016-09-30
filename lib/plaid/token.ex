defmodule Plaid.Token do
  @moduledoc """
  Functions for working with a Plaid token. Through this API you can:

  * Exchange a public token for an access_token

  Plaid API Reference: https://plaid.com/docs/quickstart/#-exchange_token-endpoint

  ** Need to add account_id payload **
  """

  alias Plaid.Utilities

  defstruct [:access_token, :sandbox]

  @endpoint "exchange_token"

  @doc """
  Exchange a public token.

  Exchanges a user's public token for an access token. Uses credentials in the
  configuration. Accepts params as a binary or a map.

  Returns an access token or `Plaid.Error` struct.

  Payload
  * `params` - user public_token - `string` or `map` - required

  ## Example
  ```
  params = "test,bofa,connected" OR %{public_token: "test,bofa,connected"}

  {:ok, access_token} = Plaid.Token.exchange(params)
  {:error, %Plaid.Error{...}} = Plaid.Token.exchange(params)
  ```
  """
  @spec exchange(binary | map) :: {atom | map}
  def exchange(params) do
    exchange params, Plaid.config_or_env_cred()
  end

  @doc """
  Same as Plaid.Token.exchange/1 but with user-supplied credentials.

  ## Example

    params = "test,bofa,connected"
    cred = %{client_id: "test_id", secret: "test_secret"}

    {:ok, access_token} = Plaid.Token.exchange(params, cred)
    {:error, %Plaid.Error{...}} = Plaid.Token.exchange(params, cred)

  """
  @spec exchange(binary, map) :: {atom | map}
  def exchange(params, cred) when is_binary(params) do
    params = Map.new |> Map.put(:public_token, params)
    Plaid.make_request_with_cred(:post, @endpoint, cred, params)
    |> Utilities.handle_plaid_response(:token)
  end

  @doc """
  Same as Plaid.Token.exchange/1 but with user-supplied credentials.

  Params are supplied as a map.

  Payload
    `public_token` - user's public_token - string; required

  ## Example

    params = %{public_token: "test,bofa,connected"}
    cred = %{client_id: "test_id", secret: "test_secret"}

    {:ok, access_token} = Plaid.Token.exchange(params, cred)
    {:error, %Plaid.Error{...}} = Plaid.Token.exchange(params, cred)

  """
  @spec exchange(map, map) :: {atom, map}
  def exchange(%{public_token: _} = params, cred) do
    Plaid.make_request_with_cred(:post, @endpoint, cred, params)
    |> Utilities.handle_plaid_response(:token)
  end

end
