defmodule Plaid.Connect do
  @moduledoc """
  Functions for working with Plaid Connect endpoint. Through this API you can:

  * Add a Plaid Connect user
  * Register a webhook for a user
  * Fetch user account data
  * Fetch user transaction data
  * Specify MFA delivery options
  * Submit MFA responses
  * Update user credentials
  * Delete a user

  All requests are submitted as maps with the parameter name as the key
  and value as value: `%{key: value}`. Keys can be strings or atoms.

  The functionality is performed by five functions: `add`, `mfa`, `connect`,
  `update` and `delete`. The specific requests are determined by the payload.

  Each function accepts user-supplied credentials, but uses the credentials
  specified in the configuration by default. The credentials are provided
  as a map: `%{client_id: value, secret: value}`

  Payload (Credentials)
  * `client_id` - Plaid `CLIENT_ID` - `string` - required
  * `secret` - Plaid `SECRET` - `string` - required
  """

  alias Plaid.Utilities

  defstruct [:accounts, :access_token, :transactions]

  @endpoint "connect"

  @doc """
  Adds a Connect user.

  Adds a Plaid Connect user using the username and password of the specified
  financial institution. Uses credentials supplied in the configuration.

  Returns `Plaid.Connect`, `Plaid.MfaQuestion`, `Plaid.MfaMask` or `Plaid.Error` struct.

  Payload
  * `type` - Plaid institution code - `string` - required
  * `username` - user login - `string` - required
  * `password` - user password - `string` - required
  * `pin` - user pin - `string` - required for USAA `type` only
  * `options` - optional parameters (below) - `map` - optional
  * `login_only` - add user only, does not return transactions - `boolean`
  * `webhook` - url to which webhook messages will be sent - `string`
  * `pending` - return pending transactions - `boolean`
  * `start_date` - if `login_only` is false, earliest date for which transactions will be returned - `string` formatted "YYYY-MM-DD"
  * `end_date` - if `login_only` is false, latest date for which transactions will be returned - `string` format "YYYY-MM-DD"
  * `list` - MFA delivery methods - `boolean`

  ## Example
  ```
  params = %{username: "plaid_test", password: "plaid_good", type: "bofa",
             options: %{login_only: true, webhook: "http://requestb.in/",
              pending: false, start_date: "2015-01-01", end_date: "2015-03-31"},
              list: true}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.add(params)
  {:ok, %Plaid.MfaQuestion{...}} = Plaid.Connect.add(params)
  {:ok, %Plaid.MfaMask{...}} = Plaid.Connect.add(params)
  {:error, %Plaid.Error{...}} = Plaid.Connect.add(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#add-connect-user
  """
  @spec add(map) :: {atom, map}
  def add(params) do
    add params, Plaid.config_or_env_cred()
  end

  @doc """
  Adds a Connect user with user-supplied credentials.

  ## Example
  ```
  params = %{username: "plaid_test", password: "plaid_good", type: "bofa",
             options: %{login_only: true, webhook: "http://requestb.in/",
              pending: false, start_date: "2015-01-01", end_date: "2015-03-31"},
              list: true}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.add(params, cred)
  {:ok, %Plaid.MfaQuestion{...}} = Plaid.Connect.add(params, cred)
  {:ok, %Plaid.MfaMask{...}} = Plaid.Connect.add(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.add(params, cred)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#add-connect-user
  """
  @spec add(map, map) :: {atom, map}
  def add(params, cred) when is_map(cred) and is_map(params) do
    Plaid.make_request_with_cred(:post, @endpoint, cred, params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Submits MFA choice confirmation and MFA answer.

  Submits MFA choice confirmation or MFA answer to Plaid connect/step endpoint.
  The request is determined by the payload. Used in response to an
  MFA question response following a Plaid.Connect.add/1 request. Uses
  credentials supplied in the configuration.

  Returns `Plaid.Connect`, `Plaid.MfaMessage` or `Plaid.Error` struct.

  Payload (Choice Confirmation)
  * `access_token` - user `ACCESS_TOKEN` - `string` - required
  * `options` - options for MFA (below) - `map` - required
  * `send_method` - delivery modality for MFA request - `map`

  Payload (MFA Answer)
  * `access_token` - user `ACCESS_TOKEN` - `string` - required
  * `mfa` - user response to MFA question - `string` - required

  ## Example
  ```
  params = %{access_token: "test_bofa", mfa: "tomato"}
          OR
           %{access_token: "test_bofa", options: %{send_method:
              %{type: "phone"}}}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.mfa(params)
  {:ok, %Plaid.MfaMessage{...}} = Plaid.Connect.mfa(params)
  {:error, %Plaid.Error{...}} = Plaid.Connect.mfa(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#connect-mfa
  """
  @spec mfa(map) :: {atom, map}
  def mfa(params) do
    mfa params, Plaid.config_or_env_cred()
  end

  @doc """
  Submits MFA choice confirmation and MFA answer with user-supplied credentials.

  ## Example
  ```
  params = %{access_token: "test_bofa", mfa: "tomato"}
          OR
           %{access_token: "test_bofa", options: %{send_method:
              %{type: "phone"}}}

  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.mfa(params, cred)
  {:ok, %Plaid.MfaMessage{...}} = Plaid.Connect.mfa(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.mfa(params, cred)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#connect-mfa
  """
  @spec mfa(map, map) :: {atom, map}
  def mfa(params, cred) do
    endpoint = @endpoint <> "/step"
    Plaid.make_request_with_cred(:post, endpoint, cred, params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Gets Plaid data.

  Gets a user's account and transaction data as specified in the params. Uses
  credentials specified in the configuration.

  Returns `Plaid.Connect` or `Plaid.Error` struct.

  Payload
  * `access_token` - user `ACCESS_TOKEN` - `string` - required
  * `options` - optional parameters (below) - `map` - optional
  * `pending` - return pending transactions - `boolean`
  * `account` - Plaid account `_id` for which to return transactions - `string`
  * `gte` - earliest date for which transactions will be returned - `string` formatted "YYYY-MM-DD"
  * `lte` - latest date for which transactions will be returned - `string` formatted "YYYY-MM-DD"

  ## Example
  ```
  params = %{access_token: "test_bofa", options: %{pending: false,
             account: "QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK",
             gte: "2012-01-01", lte: "2016-01-01"}}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.get(params)
  {:error, %Plaid.Error{...}} = Plaid.Connect.get(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#get-transactions
  """
  @spec get(map) :: {atom, map}
  def get(params) do
    get params, Plaid.config_or_env_cred()
  end

  @doc """
  Gets Plaid data with user-supplied credentials.

  ## Example
  ```
  params = %{access_token: "test_bofa", options: %{pending: false,
             account: "QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK",
             gte: "2012-01-01", lte: "2016-01-01"}}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.get(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.get(params, cred)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#get-transactions
  """
  @spec get(map, map) :: {atom, map}
  def get(params, cred) do
    endpoint = @endpoint <> "/get"
    Plaid.make_request_with_cred(:post, endpoint, cred, params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Updates a user's credentials.

  Patches a user's credentials or webhook url in Plaid. New credentials
  must be submitted for an existing user identified by the `ACCESS_TOKEN`.
  Request is determined by the payload. Uses credentials specified in the
  configuration.

  Returns `Plaid.Connect`, `Plaid.MfaQuestion` or `Plaid.Error` struct.

  Payload (Connect)
  * `access_token` - user `ACCESS_TOKEN` - `string` - required
  * `username` - user login - `string` - required
  * `password` - user password - `string` - required
  * `pin` - user pin - `string` - required for USAA only

  Payload (Webhook)
  * `access_token` - user `ACCESS_TOKEN` - `string` - required
  * `options` - parameters (below) - `map` - required
  * `webhook` - url to which webhook messages will be sent - `string`

  ## Example
  ```
  params = %{access_token: "test_bofa", username: "plaid_test",
             password: "plaid_good"}
          OR
           %{access_token: "test_bofa", options: %{webhook: "http://requestb.in/"}}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.update(params)
  {:ok, %Plaid.MfaQuestion{...}} = Plaid.Connect.update(params)
  {:error, %Plaid.Error{...}} = Plaid.Connect.update(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#update-connect-user
  """
  @spec update(map) :: {atom, map}
  def update(params) do
    update params, Plaid.config_or_env_cred()
  end

  @doc """
  Updates a user's MFA credentials.

  Payload (MFA)
  * `access_token` - user `ACCESS_TOKEN` - `string` - required
  * `mfa` - user response to MFA question - `string` - required

  ## Example
  ```
  params = %{access_token: "test_bofa", mfa: "tomato"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.update(params, :mfa)
  {:error, %Plaid.Error{...}} = Plaid.Connect.update(params, :mfa)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#update-connect-user
  """
  @spec update(map, atom) :: {atom, map}
  def update(params, :mfa) do
    update params, Plaid.config_or_env_cred, :mfa
  end

  @doc """
  Updates a user's credentials with user-supplied credentials.

  ## Example
  ```
  params = %{access_token: "test_bofa", username: "plaid_test",
             password: "plaid_good"}
          OR
           %{access_token: "test_bofa", options: %{webhook: "http://requestb.in/"}}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.update(params, cred)
  {:ok, %Plaid.MfaQuestion{...}} = Plaid.Connect.update(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.update(params, cred)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#update-connect-user
  """
  @spec update(map, map) :: {atom, map}
  def update(params, cred) do
    Plaid.make_request_with_cred(:patch, @endpoint, cred, params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Updates a user's MFA credentials with user-supplied credentials.

  ## Example
  ```
  params = %{access_token: "test_bofa", mfa: "tomato"}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Connect{...}} = Plaid.Connect.update(params, cred, :mfa)
  {:error, %Plaid.Error{...}} = Plaid.Connect.update(params, cred, :mfa)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#update-connect-user
  """
  @spec update(map, map, atom) :: {atom, map}
  def update(params, cred, :mfa) do
    endpoint = @endpoint <> "/step"
    Plaid.make_request_with_cred(:patch, endpoint, cred, params)
    |> Utilities.handle_plaid_response(:connect)
  end

  @doc """
  Deletes a Connect user.

  Deletes a user from the Plaid connect endpoint.

  Returns a `Plaid.Message` or `Plaid.Error` struct.

  Payload
  * `access_token` - user `ACCESS_TOKEN` - `string` - required

  ## Example
  ```
  params = %{access_token: "test_bofa"}

  {:ok, %Plaid.Message{...}} = Plaid.Connect.delete(params)
  {:error, %Plaid.Error{...}} = Plaid.Connect.delete(params)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#delete-connect-user
  """
  @spec delete(map) :: {atom, map}
  def delete(params) do
    delete params, Plaid.config_or_env_cred()
  end

  @doc """
  Deletes a Connect user with user-supplied credentials.

  ## Example
  ```
  params = %{access_token: "test_bofa"}
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, %Plaid.Message{...}} = Plaid.Connect.delete(params, cred)
  {:error, %Plaid.Error{...}} = Plaid.Connect.delete(params, cred)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#delete-connect-user
  """
  @spec delete(map, map) :: {atom, map}
  def delete(params, cred) do
    Plaid.make_request_with_cred(:delete, @endpoint, cred, params)
    |> Utilities.handle_plaid_response(:connect)
  end

end
