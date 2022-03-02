defmodule Plaid do
  @moduledoc """
  An HTTP Client for Plaid.

  [Plaid API Docs](https://plaid.com/docs/api)
  """

  use HTTPoison.Base

  @events_prefix [:plaid, :request]

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

  @callback valid_credentials?(map) :: true | no_return
  def valid_credentials?(config) do
    _ = get_client_id(config)
    _ = get_secret(config)
    true
  end

  @callback make_request(atom, String.t(), map, map | nil) ::
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def make_request(method, endpoint, parameters, config \\ %{}) do
    request_body = build_request_body(parameters, config)
    url = "#{get_root_uri(config)}#{endpoint}"
    headers = [{"Content-Type", "application/json"}]
    options = build_http_client_options(config)
    metadata = build_instrumentation_metadata(method, endpoint, config)
    client = config[:client] || PlaidHTTP
    telemetry = config[:telemetry] || PlaidTelemetry

    telemetry.instrument(
      fn -> client.call(method, url, request_body, headers, options) end,
      metadata
    )
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
  Makes request with credentials.
  """
  @callback make_request_with_cred(atom, String.t(), map, map | nil, map | nil, Keyword.t() | nil) ::
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def make_request_with_cred(method, endpoint, config, body \\ %{}, headers \\ %{}, options \\ []) do
    passed_metadata = config[:telemetry_metadata] || %{}

    common_metadata =
      Map.merge(passed_metadata, %{
        method: method,
        path: endpoint,
        u: :native
      })

    with_metrics(
      fn ->
        request_endpoint = "#{get_root_uri(config)}#{endpoint}"
        cred = Map.take(config, [:client_id, :secret])
        request_body = Map.merge(body, cred) |> Poison.encode!()
        request_headers = get_request_headers() |> Map.merge(headers) |> Map.to_list()

        options =
          default_httpoison_request_options()
          |> Keyword.merge(Map.get(config, :httpoison_options, []))
          |> Keyword.merge(options)

        request(method, request_endpoint, request_body, request_headers, options)
      end,
      common_metadata
    )
  end

  defp with_metrics(action, metadata) do
    start_time = System.monotonic_time()

    :telemetry.execute(@events_prefix ++ [:start], %{system_time: start_time}, metadata)

    try do
      action.()
    rescue
      exception ->
        :telemetry.execute(
          @events_prefix ++ [:exception],
          %{duration: System.monotonic_time() - start_time},
          Map.put(metadata, :exception, exception)
        )

        reraise exception, __STACKTRACE__
    else
      {:ok, response} = result ->
        :telemetry.execute(
          @events_prefix ++ [:stop],
          %{duration: System.monotonic_time() - start_time},
          Map.merge(metadata, %{result: result, status: response.status_code})
        )

        result

      {:error, _reason} = result ->
        :telemetry.execute(
          @events_prefix ++ [:stop],
          %{duration: System.monotonic_time() - start_time},
          Map.put(metadata, :result, result)
        )

        result
    end
  end

  def process_response_body(body) do
    Poison.Parser.parse!(body, %{})
  end

  defp get_request_headers do
    Map.new()
    |> Map.put("Content-Type", "application/json")
  end

  defp default_httpoison_request_options do
    Application.get_env(:plaid, :httpoison_options, [])
  end

  @doc """
  Gets the `client_id` and `secret` from config argument or the library configuration.
  """
  @spec validate_cred(map) :: map | no_return
  def validate_cred(config) do
    %{
      client_id: get_client_id(config),
      secret: get_secret(config),
      root_uri: get_root_uri(config),
      httpoison_options: Map.get(config, :httpoison_options, [])
    }
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

  defp get_root_uri(config) do
    case config[:root_uri] || Application.get_env(:plaid, :root_uri) do
      nil ->
        raise MissingRootUriError

      root_uri ->
        root_uri
    end
  end
end
