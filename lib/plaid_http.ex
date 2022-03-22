defmodule PlaidHTTP do
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

  @callback call(atom, binary, map, keyword, keyword, map) ::
              {:ok, PlaidHTTP.Response.t()} | {:error, PlaidHTTP.Error.t()}
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
        {:ok, %PlaidHTTP.Response{status_code: status, body: Poison.Parser.parse!(body, %{})}}

      {:error, reason} ->
        {:error, %PlaidHTTP.Error{reason: reason}}
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
