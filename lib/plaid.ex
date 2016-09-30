defmodule Plaid do
  @moduledoc """
  An HTTP Client for Plaid.

  ## Configuring
  All calls to plaid require a `ROOT_URI` (production or development), a `CLIENT_ID`
  and `SECRET`. These values are configured in the `config.exs` file of your
  application.

  The environment variables for `PLAID_CLIENT_ID` and `PLAID_SECRET` will be used
  if no variables are configured.
  ```
  config :plaid, client_id: "YOUR_CLIENT_ID"
  config :plaid, secret: "YOUR_SECRET"
  config :plaid, root_uri: "DEV_OR_PROD_URI"
  ```
  """

  alias Plaid.Utilities

  use HTTPoison.Base

  defmodule MissingSecretError do
    defexception message: """
    The secret is required for all calls to Plaid. Please configure secret
    in your config.exs and environment specific config files.
    config :plaid, secret: YOUR_SECRET

    If you haven't registered with Plaid for a secret, you can still test
    the API with the following test credentials:
    config: :plaid, secret: "plaid_good"
    """
  end

  defmodule MissingClientIdError do
    defexception message: """
    The client_id is required for all call to Plaid. Please configure client_id
    in your config.exs and environment specific config files.
    config :plaid, client_id: YOUR_CLIENT_ID

    If you haven't registered with Plaid for a client_id, you can still test
    the API with the following test credentials:
    config: :plaid, client_id: "plaid_test"
    """
  end

  defmodule MissingRootUriError do
    defexception message: """
    The root_uri is required to specify the Plaid environment to which you are
    making calls, i.e. development or production. Please configure root_uri in
    your config.exs file.
    config :plaid, root_uri: "https://tartan.plaid.com/" (development)
    config :plaid, root_uri: "https://api.plaid.com/" (production)
    """
  end

  @doc """
  Fetches credentials from `config.exs`.

  Returns a map or raises if not found.
  """
  @spec config_or_env_cred() :: binary | map
  def config_or_env_cred() do
    require_plaid_credentials()
  end

  @doc """
  Fetches url using the root_uri specified in `config.exs` (dev or prod).

  Returns binary.
  """
  @spec process_url(binary) :: binary
  def process_url(endpoint) do
    require_root_uri <> endpoint
  end

  @doc """
  Sets request headers.
  """
  def request_headers() do
    Map.new
    |> Map.put("Content-Type", "application/x-www-form-urlencoded")
  end

  @doc """
  Boiler plate code to make calls to the Plaid API. Credentials are read from
  the configuration file using `Plaid.config_or_env_cred/0`.

  Arguments
  * `method` - request method - `atom`
  * `endpoint` - request endpoint - `string`
  * `body` - request body (excluding credentials) - `map`
  * `headers` - request headers - `map`
  * `options` - HTTPoison options - `list`
  """
  @spec make_request(atom, binary, map, map, list) :: tuple
  def make_request(method, endpoint, body \\ %{}, headers \\ %{}, options \\ []) do
    make_request_with_cred(method, endpoint, config_or_env_cred(), body, headers, options)
  end

  @doc """
  Boiler plate code to make calls to the Plaid API. Credentials are supplied.

  Arguments
  * `method` - request method - `atom`
  * `endpoint` - request endpoint - `string`
  * `cred` - Plaid credentials - `map`
  * `body` - request body (excluding credentials) - `map`
  * `headers` - request headers - `map`
  * `options` - HTTPoison options - `list`
  """
  @spec make_request_with_cred(atom, binary, map, map, map, list) :: tuple
  def make_request_with_cred(method, endpoint, cred, body \\ %{}, headers \\ %{}, options \\ []) do
    rb = Utilities.encode_params(cred, body)
    rh = request_headers |> Map.merge(headers) |> Map.to_list
    options = httpoison_request_options() ++ options
    {:ok, response} = request(method, endpoint, rb, rh, options)
    response
  end

  ## Private functions.

  defp require_plaid_credentials() do
    client_id = Application.get_env(:plaid, :client_id, System.get_env("PLAID_CLIENT_ID")) || :not_found
    secret = Application.get_env(:plaid, :secret, System.get_env("PLAID_SECRET")) || :not_found
    case {client_id, secret} do
      {:not_found, _} ->
        raise MissingClientIdError
      {_, :not_found} ->
        raise MissingSecretError
      {client_id, secret} ->
        %{client_id: client_id, secret: secret}
    end
  end

  defp require_root_uri() do
    case Application.get_env(:plaid, :root_uri) || :not_found do
      :not_found ->
        raise MissingRootUriError
      value ->
        value
    end
  end

  defp httpoison_request_options() do
    Application.get_env(:plaid, :httpoison_options, [])
  end
end
