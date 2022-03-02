defmodule PlaidHTTP do
  use HTTPoison.Base

  @callback call(atom, String.t(), map, Keyword.t(), Keyword.t()) ::
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def call(method, url, body, headers, options) do
    request(method, url, body, headers, options)
  end

  # HTTPoison magic to encode HTTP request body before sending.
  @impl true
  def process_request_body(body) do
    Poison.encode!(body)
  end

  # More magic to parse binary HTTP response body into map with string keys.
  @impl true
  def process_response_body(body) do
    Poison.Parser.parse!(body, %{})
  end
end
