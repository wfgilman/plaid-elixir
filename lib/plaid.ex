defmodule Plaid do
  @moduledoc """
  An HTTP Client for Plaid.

  [Plaid API Docs](https://plaid.com/docs/api)
  """

  defmodule MissingClientIdError do
    defexception message: """
                 The `client_id` is required for calls to Plaid. Please either configure `client_id`
                 in your config.exs file or pass it into the function via the `config` argument.

                 config :plaid, client_id: "your_client_id"
                 """
  end

  defmodule MissingSecretError do
    defexception message: """
                 The `secret` is required for calls to Plaid. Please either configure `secret`
                 in your config.exs file or pass it into the function via the `config` argument.

                 config :plaid, secret: "your_secret"
                 """
  end

  defmodule MissingRootUriError do
    defexception message: """
                 The root_uri is required to specify the Plaid environment to which you are
                 making calls, i.e. sandbox, development or production. Please configure root_uri in
                 your config.exs file.

                 config :plaid, root_uri: "https://sandbox.plaid.com/" (test)
                 config :plaid, root_uri: "https://development.plaid.com/" (development)
                 config :plaid, root_uri: "https://production.plaid.com/" (production)
                 """
  end

  @type method :: atom
  @type endpoint :: String.t()
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type response :: {:ok, Plaid.HTTPClient.Response.t()} | {:error, Plaid.HTTPClient.Error.t()}

  @doc """
  Validate credentials for the HTTP request.

  Takes runtime Plaid credentials and ensures a value is provided for `client_id`
  and `secret`. Falls back to the library configuration if not provided in
  the `config` argument. If neither contains the required credentials, the
  functions raises a `MissingClientIdError` or `MissingSecretError`
  """
  @callback valid_credentials?(config) :: true | no_return

  @doc """
  Makes HTTP request to Plaid.

  Build the HTTP request by combining the arguments with system configuration
  and default values, then hands the request to the client passed in the
  optional `config` argument. Client defaults to `Plaid.HTTPClient`.

  Returns either `{:ok, %Plaid.HTTPClient.Response{}}` or `{:error, %Plaid.HTTPClient.Error{}}`

  Example
  ```
  Plaid.make_request(:post, "accounts/get", %{access_token: "my-token"})

  Plaid.make_request(
    :post,
    "accounts/get",
    %{access_token: "my-token"},
    %{
      http_client: MyHTTPClient,
      http_options: [recv_timeout: 10_000]
    }
  )
  ```
  """
  @callback make_request(method, endpoint, params, config) :: response

  @doc """
  Handles HTTP response from Plaid.

  Accepts the response from `Plaid.make_request/5` and maps it to an internal
  data structure.
  """
  @callback handle_response(
              response,
              endpoint,
              config
            ) :: {:ok, term} | {:error, Plaid.Error.t() | Plaid.HTTPClient.Error.t()} | no_return

  @doc false
  def valid_credentials?(config) do
    _ = get_client_id(config)
    _ = get_secret(config)
    true
  end

  defp get_client_id(config) do
    case config[:client_id] || Application.get_env(:plaid, :client_id) do
      nil ->
        raise MissingClientIdError

      client_id ->
        client_id
    end
  end

  defp get_secret(config) do
    case config[:secret] || Application.get_env(:plaid, :secret) do
      nil ->
        raise MissingSecretError

      secret ->
        secret
    end
  end

  @doc false
  def make_request(method, endpoint, parameters, config \\ %{}) do
    url = "#{get_root_uri(config)}#{endpoint}"
    request_body = build_request_body(parameters, config)
    headers = [{"Content-Type", "application/json"}]
    http_options = build_http_client_options(config)
    metadata = build_instrumentation_metadata(method, endpoint, config)

    http_client = config[:http_client] || Plaid.HTTPClient

    http_client.call(method, url, request_body, headers, http_options, metadata)
  end

  defp get_root_uri(config) do
    case config[:root_uri] || Application.get_env(:plaid, :root_uri) do
      nil ->
        raise MissingRootUriError

      root_uri ->
        root_uri
    end
  end

  defp build_request_body(parameters, config) do
    config
    |> Map.take([:client_id, :secret])
    |> Map.merge(parameters)
  end

  defp build_http_client_options(config) do
    Keyword.merge(
      Application.get_env(:plaid, :http_options, []),
      config[:http_options] || []
    )
  end

  defp build_instrumentation_metadata(method, endpoint, config) do
    Map.new()
    |> Map.put(:method, method)
    |> Map.put(:path, endpoint)
    |> Map.put(:u, :native)
    |> Map.merge(config[:telemetry_metadata] || %{})
  end

  @doc false
  def handle_response(response, endpoint, config \\ %{}) do
    handler = config[:handler] || Plaid.Handler
    handler.handle_resp(response, endpoint)
  end
end
