defmodule Plaid.Connect do
  @moduledoc """
  Functions for working with Plaid Connect.

  Through this API you can:

  * Add a Plaid Connect user
  * Register a webhook for a user
  * Fetch user account data
  * Fetch user transaction data
  * Specify MFA delivery options
  * Submit MFA responses
  * Update user credentials
  * Delete a user

  All requests are submitted as maps with the parameter name as the key
  and value as value: `%{key: value}`.

  The functionality is performed by five functions: `add`, `mfa`, `get`,
  `update` and `delete`. The specific requests are determined by the payload.

  Each function accepts user-supplied credentials, but uses the credentials
  specified in the configuration by default. The credentials are provided
  as a map: `%{client_id: value, secret: value}`

  Payload (Credentials)
  * `client_id` - `string` - req - Plaid `CLIENT_ID`
  * `secret`    - `string` - req - Plaid `SECRET`
  """

  alias Plaid.Utilities

  defstruct [:accounts, :access_token, :transactions]

  @endpoint "connect"

  @doc """
  Adds a Connect user.

  Adds a Plaid Connect user using the username and password of the specified
  financial institution. If credentials are not supplied, credentials in the
  default configuration are used.

  Returns `Plaid.Connect`, `Plaid.Mfa` or `Plaid.Error` struct.

  Args
  * `params`  - `map` - req - Payload
  * `cred`    - `map` - opt - Plaid credentials

  Payload
  * `type`       - `string` - req - Plaid institution code
  * `username`   - `string` - req - User's username login
  * `password`   - `string` - req - User's password
  * `pin`        - `string` - req - User's PIN (for USAA only)
  * `options`    - `map`    - opt - Optional parameters (below)
  * `login_only` - `boolean`      - Add user only
  * `webhook`    - `string`       - Url to which webhook messages will be sent
  * `pending`    - `boolean`      - Return pending transactions
  * `start_date` - `string`       - If `login_only` is false, earliest date for which transactions will be returned, formatted "YYYY-MM-DD"
  * `end_date`   - `string`       - If `login_only` is false, latest date for which transactions will be returned, format "YYYY-MM-DD"
  * `list`       - `boolean`      - Return MFA delivery methods

  ## Example
  ```
  params = %{username: "plaid_test", password: "plaid_good", type: "bofa",
             options: %{login_only: true, webhook: "http://requestb.in/",
              pending: false, start_date: "2015-01-01", end_date: "2015-03-31"},
              list: true}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.add(params)
  {:ok, %Plaid.Connect{...}} = Plaid.Connect.add(params, cred)
  {:ok, %Plaid.Mfa{...}} = Plaid.Connect.add(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.add(params, cred)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#add-connect-user
  """
  @spec add(map, map) :: {atom, map}
  def add(params, cred \\ nil) do
    Plaid.make_request_with_cred(:post, @endpoint, cred || Plaid.config_or_env_cred(), params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Submits MFA choice confirmation and MFA answer.

  Submits MFA choice confirmation or MFA answer to Plaid connect/step endpoint.
  The request is determined by the payload. Used in response to an
  MFA question response following a Plaid.Connect.add/1 request. If credentials
  are not supplied, credentials in the default configuration are used.

  Returns `Plaid.Connect`, `Plaid.Mfa` or `Plaid.Error` struct.

  Args
  * `params`  - `map` - req - Payload, choice confirmation or MFA answer
  * `cred`    - `map` - opt - Plaid credentials

  Payload (Choice Confirmation)
  * `access_token` - `string` - req - User's `ACCESS_TOKEN`
  * `options`      - `map`    - req - Options for MFA (below)
  * `send_method`  - `map`    - req - Delivery modality for MFA request

  Payload (MFA Answer)
  * `access_token` - `string` - req - User's `ACCESS_TOKEN`
  * `mfa`          - `string` - req - User's response to MFA question

  ## Example
  ```
  params = %{access_token: "test_bofa", mfa: "tomato"}
          OR
           %{access_token: "test_bofa", options: %{send_method: %{type: "phone"}}}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.mfa(params)
  {:ok, %Plaid.Connect{...}} = Plaid.Connect.mfa(params, cred)
  {:ok, %Plaid.Mfa{...}} = Plaid.Connect.mfa(params)
  {:error, %Plaid.Error{...}} = Plaid.Connect.mfa(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#connect-mfa
  """
  @spec mfa(map, map) :: {atom, map}
  def mfa(params, cred \\ nil) do
    endpoint = @endpoint <> "/step"
    Plaid.make_request_with_cred(:post, endpoint, cred || Plaid.config_or_env_cred(), params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Gets Plaid data.

  Gets a user's account and transaction data as specified in the params. If
  credential are not supplied, credentials in the default configuration are used.

  Returns `Plaid.Connect` or `Plaid.Error` struct.

  Args
  * `params` - `map` - req - Payload
  * `cred`   - `map` - opt - Plaid credentials

  Payload
  * `access_token` - `string`  - req - User's `ACCESS_TOKEN`
  * `options`      - `map`     - opt - Optional parameters (below)
  * `pending`      - `boolean`       - Return pending transactions
  * `account`      - `string`        - Plaid account `_id` for which to return transactions
  * `gte`          - `string`        - Earliest date for which transactions will be returned, formatted "YYYY-MM-DD"
  * `lte`          - `string`        - Latest date for which transactions will be returned, formatted "YYYY-MM-DD"

  ## Example
  ```
  params = %{access_token: "test_bofa", options: %{pending: false,
             account: "QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK",
             gte: "2012-01-01", lte: "2016-01-01"}}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.get(params)
  {:ok, %Plaid.Connect{...}} = Plaid.Connect.get(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.get(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#get-transactions
  """
  @spec get(map, map) :: {atom, map}
  def get(params, cred \\ nil) do
    endpoint = @endpoint <> "/get"
    Plaid.make_request_with_cred(:post, endpoint, cred || Plaid.config_or_env_cred(), params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Updates a user's credentials.

  Patches a user's credentials, mfa or webhook url in Plaid. New credentials
  must be submitted for an existing user identified by the `ACCESS_TOKEN`.
  Request is determined by the payload. If credential are not supplied,
  credentials in the default configuration are used.

  Returns `Plaid.Connect`, `Plaid.Mfa` or `Plaid.Error` struct.

  Args
  * `params` - `map` - req - Payload (Connect, webhook, or MFA)
  * `cred`   - `map` - opt - Plaid credentials

  Payload (Connect)
  * `access_token` - `string` - req - User's `ACCESS_TOKEN`
  * `username`     - `string` - req - User's username
  * `password`     - `string` - req - User's password
  * `pin`          - `string` - req - User's PIN (for USAA only)

  Payload (Webhook)
  * `access_token` - `string` - req - User's `ACCESS_TOKEN`
  * `options`      - `map`    - req - Parameters (below)
  * `webhook`      - `string` - req - Url to which webhook messages will be sent

  Payload (MFA)
  * `access_token` - `string` - req - User's `ACCESS_TOKEN`
  * `mfa`          - `string` - req - User's response to MFA question

  ## Example
  ```
  params = %{access_token: "test_bofa", username: "plaid_test",
             password: "plaid_good"}
          OR
           %{access_token: "test_bofa", options: %{webhook: "http://requestb.in/"}}
          OR
           %{access_token: "test_bofa", mfa: "tomato"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.update(params)
  {:ok, %Plaid.Connect{...}} = Plaid.Connect.update(params, cred)
  {:ok, %Plaid.Mfa{...}} = Plaid.Connect.update(params)
  {:error, %Plaid.Error{...}} = Plaid.Connect.update(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#update-connect-user

  """
  @spec update(map, map) :: {atom, map}
  def update(params, cred \\ nil) do
    endpoint =
      case params do
        %{access_token: _, mfa: _} ->
          @endpoint <> "/step"
        _ ->
          @endpoint
      end
    Plaid.make_request_with_cred(:patch, endpoint, cred || Plaid.config_or_env_cred(), params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Deletes a Connect user.

  Deletes a user from the Plaid connect endpoint. If credential are not
  supplied, credentials in the default configuration are used.

  Returns a `Plaid.Message` or `Plaid.Error` struct.

  Args
  * `params` - `map` - req - Payload
  * `cred`   - `map` - opt - Plaid credentials

  Payload
  * `access_token` - `string` - req - User's `ACCESS_TOKEN`

  ## Example
  ```
  params = %{access_token: "test_bofa"}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Message{...}} = Plaid.Connect.delete(params)
  {:ok, %Plaid.Message{...}} = Plaid.Connect.delete(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.delete(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#delete-connect-user
  """
  @spec delete(map, map) :: {atom, map}
  def delete(params, cred \\ nil) do
    Plaid.make_request_with_cred(:delete, @endpoint, cred || Plaid.config_or_env_cred(), params)
    |> Utilities.handle_plaid_response(:connect)
  end

end
