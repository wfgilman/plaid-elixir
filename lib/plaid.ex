defmodule Plaid do
  @moduledoc """
  An HTTP Client for Plaid.

  Plaid API Docs: https://plaid.com/docs/api/#api-keys-and-access
  """

  use HTTPoison.Base

  defmodule MissingSecretError do
    defexception message: """
    The secret is required for calls to Plaid. Please configure secret
    in your config.exs file.

    config :plaid, client_id: "your_client_id"
    """
  end

  defmodule MissingClientIdError do
    defexception message: """
    The client_id is required for calls to Plaid. Please configure client_id
    in your config.exs file.

    config :plaid, secret: "your_secret"
    """
  end

  defmodule MissingPublicKeyError do
    defexception message: """
    The public_key is required for some unauthenticated endpoints. Please
    configure public_key in your config.exs.

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
  def get_cred do
    require_plaid_credentials()
  end

  @doc """
  Gets public_key from configuration.
  """
  @spec get_public_key() :: map | no_return
  def get_key do
    require_public_key()
  end

  @doc """
  Makes request without credentials.
  """
  @spec make_request(atom, String.t, map, map, Keyword.t) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  def make_request(method, endpoint, body \\ %{}, headers \\ %{}, options \\ []) do
    make_request_with_cred(method, endpoint, %{}, body, headers, options)
  end

  @doc """
  Makes request with credentials.
  """
  @spec make_request_with_cred(atom, String.t, map, map, map, Keyword.t) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  def make_request_with_cred(method, endpoint, cred, body \\ %{}, headers \\ %{}, options \\ []) do
    rb = Map.merge(body, cred) |> Poison.encode!()
    rh = get_request_headers() |> Map.merge(headers) |> Map.to_list()
    options = httpoison_request_options() ++ options
    request(method, endpoint, rb, rh, options)
  end

  defp process_url(endpoint) do
    require_root_uri() <> endpoint
  end

  defp process_response_body(body) do
    Poison.Parser.parse!(body)
  end

  defp get_request_headers do
    Map.new
    |> Map.put("Content-Type", "application/json")
  end

  defp require_plaid_credentials do
    case {get_client_id(), get_secret()} do
      {:not_found, _}     -> raise MissingClientIdError
      {_, :not_found}     -> raise MissingSecretError
      {client_id, secret} -> %{client_id: client_id, secret: secret}
    end
  end

  defp require_public_key do
    case get_public_key() do
      :not_found -> raise MissingPublicKeyError
      value      -> %{public_key: value}
    end
  end

  defp require_root_uri do
    case Application.get_env(:plaid, :root_uri, :not_found) do
      :not_found -> raise MissingRootUriError
      value      -> value
    end
  end

  defp httpoison_request_options do
    Application.get_env(:plaid, :httpoison_options, [])
  end

  defp get_client_id do
    Application.get_env(:plaid, :client_id) || :not_found
  end

  defp get_secret do
    Application.get_env(:plaid, :secret) || :not_found
  end

  defp get_public_key do
    Application.get_env(:plaid, :public_key) || :not_found
  end

end
