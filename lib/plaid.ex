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

  defmodule MissingPublicKeyError do
    defexception message: """
                 The `public_key` is required for some unauthenticated endpoints. Please either
                 configure `public_key` in your config.exs or pass it into the function
                 via the `config` argument.

                 config :plaid, public_key: "your_public_key"
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

  @doc """
  Validate credentials are available for the HTTP request.
  """
  @callback valid_credentials?(map) :: true | no_return
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

  @doc """
  Make HTTP request to Plaid.
  """
  @callback make_request(atom, String.t(), map, map) ::
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def make_request(method, endpoint, parameters, config \\ %{}) do
    request_body = build_request_body(parameters, config)
    url = "#{get_root_uri(config)}#{endpoint}"
    headers = [{"Content-Type", "application/json"}]
    options = build_http_client_options(config)
    metadata = build_instrumentation_metadata(method, endpoint, config)
    http_client = config[:http_client] || PlaidHTTP
    telemetry = config[:telemetry] || PlaidTelemetry

    telemetry.instrument(
      fn -> http_client.call(method, url, request_body, headers, options) end,
      metadata
    )
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
      Application.get_env(:plaid, :httpoison_options, []),
      config[:httpoison_options] || []
    )
  end

  defp build_instrumentation_metadata(method, endpoint, config) do
    Map.new()
    |> Map.put(:method, method)
    |> Map.put(:path, endpoint)
    |> Map.put(:u, :native)
    |> Map.merge(config[:telemetry_metadata] || %{})
  end

  @doc """
  Handles HTTP client response from Plaid.
  """
  @callback handle_response(
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()},
              atom,
              map
            ) :: {:ok, term} | {:error, Plaid.Error.t() | HTTPoison.Error.t()}
  def handle_response(response, endpoint, config \\ %{}) do
    handler = config[:handler] || PlaidHandler
    handler.handle_resp(response, endpoint)
  end
end
