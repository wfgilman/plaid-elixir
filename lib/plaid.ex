defmodule Plaid do
  @moduledoc """
  An HTTP Client for Plaid.

  [Plaid API Docs](https://plaid.com/docs/api)
  """

  use HTTPoison.Base

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
  Gets credentials from configuration.
  """
  @spec get_cred() :: map | no_return
  @deprecated "Use `Plaid.validate_cred/1` which accepts a runtime config argument."
  def get_cred do
    %{
      client_id: get_client_id(%{}),
      secret: get_secret(%{})
    }
  end

  @doc """
  Gets public_key from configuration.
  """
  @spec get_key() :: map | no_return
  @deprecated "Use `Plaid.validate_public_key/1` which accepts a runtime config argument."
  def get_key do
    %{
      public_key: get_public_key(%{})
    }
  end

  @doc """
  Makes request without credentials.
  """
  @spec make_request(atom, String.t(), map, map, Keyword.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  @deprecated "Use `Plaid.make_request_with_cred/3`. This function doesn't allow runtime configuration of the root_uri."
  def make_request(method, endpoint, body \\ %{}, headers \\ %{}, options \\ []) do
    make_request_with_cred(method, endpoint, %{}, body, headers, options)
  end

  @events_prefix [:plaid, :request]

  @doc """
  Makes request with credentials.
  """
  @spec make_request_with_cred(atom, String.t(), map, map, map, Keyword.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def make_request_with_cred(method, endpoint, config, body \\ %{}, headers \\ %{}, options \\ []) do
    common_metadata = %{
      method: method,
      path: endpoint,
      u: :native
    }

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
          Map.put(metadata, :status, response.status_code)
        )

        result

      {:error, _reason} = result ->
        :telemetry.execute(
          @events_prefix ++ [:stop],
          %{duration: System.monotonic_time() - start_time},
          metadata
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

  @doc """
  Gets the `public_key` from the config argument or library configuration.
  """
  @deprecated "Plaid no longer uses public keys for new accounts."
  @spec validate_public_key(map) :: map | no_return
  def validate_public_key(config) do
    %{
      public_key: get_public_key(config),
      root_uri: get_root_uri(config)
    }
  end

  defp get_client_id(config) do
    case Map.get(config, :client_id) || Application.get_env(:plaid, :client_id) do
      nil ->
        raise MissingClientIdError

      client_id ->
        client_id
    end
  end

  defp get_secret(config) do
    case Map.get(config, :secret) || Application.get_env(:plaid, :secret) do
      nil ->
        raise MissingSecretError

      secret ->
        secret
    end
  end

  defp get_public_key(config) do
    case Map.get(config, :public_key) || Application.get_env(:plaid, :public_key) do
      nil ->
        raise MissingPublicKeyError

      public_key ->
        public_key
    end
  end

  defp get_root_uri(config) do
    case Map.get(config, :root_uri) || Application.get_env(:plaid, :root_uri) do
      nil ->
        raise MissingRootUriError

      root_uri ->
        root_uri
    end
  end
end
