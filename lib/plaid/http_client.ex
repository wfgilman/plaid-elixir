defmodule Plaid.HTTPClient do
  @moduledoc """
  HTTP Client behaviour default implementation.
  """

  defmodule Response do
    @derive Jason.Encoder
    defstruct status_code: nil, body: nil
    @type t :: %__MODULE__{status_code: integer, body: term}
  end

  defmodule Error do
    @derive Jason.Encoder
    defexception reason: nil, message: nil
    @type t :: %__MODULE__{reason: term}
    @impl true
    def message(%Error{reason: reason, message: nil}),
      do: "http request failed with reason: #{inspect(reason)}"

    def message(%Error{reason: nil, message: message}), do: message
  end

  @type method :: atom
  @type url :: String.t()
  @type body :: map
  @type headers :: keyword
  @type http_options :: keyword
  @type metadata :: map
  @type response :: {:ok, Plaid.HTTPClient.Response.t()} | {:error, Plaid.HTTPClient.Error.t()}

  @doc """
  Sends HTTP request using default configuration.

  Default HTTP Client implementation using Tesla. Function accepts request
  arguments: `method`, `url`, `body`, `headers`, HTTP client configuration options,
  and metadata for telemetry and then sends the request.

  The function must return either `{:ok, %Plaid.HTTPClient.Response{}}`
  or `{:error, %Plaid.HTTPClient.Error{}}`.

  Default implementation uses a Tesla client with the following options:
  ```
  adapter = {Tesla.Adapter.Hackney, []}
  middleware = [Tesla.Middleware.JSON, Plaid.Telemetry]
  ```

  Users can modify this implementation by creating their own module which
  implements the `Plaid.HTTPClient` behaviour and setting it in their library
  configuration under `:http_client` or passing it in the configuration
  argument at runtime.
  """
  @callback call(method, url, body, headers, http_options, metadata) :: response

  @doc false
  def call(method, url, body, headers, http_options \\ [], metadata \\ %{}) do
    client = build_client(http_options)

    options = [
      method: method,
      url: url,
      headers: headers,
      body: body,
      opts: [metadata: metadata]
    ]

    case Tesla.request(client, options) do
      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:ok, %Plaid.HTTPClient.Response{status_code: status, body: Jason.decode!(body)}}

      {:error, reason} ->
        {:error, %Plaid.HTTPClient.Error{reason: reason}}
    end
  end

  defp build_client(http_options) do
    middleware = [
      Tesla.Middleware.JSON,
      Plaid.Telemetry
    ]

    adapter = {Tesla.Adapter.Hackney, http_options}
    Tesla.client(middleware, adapter)
  end
end
