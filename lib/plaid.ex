defmodule Plaid do
  @moduledoc """
  An HTTP Client for Plaid.

  [Plaid API Docs](https://plaid.com/docs/api)
  """

  alias Plaid.Client.Request

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

  @type mapper :: (any() -> any())

  @doc """
  Send an HTTP request to Plaid.

  Takes a data structure `Plaid.Request.t` and Tesla client built at runtime
  and returns either `{:ok, Tesla.Env.t}` or `{:error, any()}`.
  """
  @callback send_request(Request.t(), Tesla.Client.t()) :: {:ok, Tesla.Env.t()} | {:error, any()}

  @doc """
  Handle an HTTP response from Plaid.

  Takes response argument in the form of `{:ok, Tesla.Env.t}` or `{:error, any()}`
  and a 1-arity mapping function argument which is applied to the body of the
  Tesla.Env in the success case to unmarshal JSON into structured data.

  Error cases are diverted into `{:error, Plaid.Error.t}` and `{:error, any()}`
  for handling Plaid and HTTP failure responses.
  """
  @callback handle_response({:ok, Tesla.Env.t()} | {:error, any()}, mapper) ::
              {:ok, term} | {:error, Plaid.Error.t()} | {:error, any()}

  # Behaviour implementation

  @doc false
  def send_request(request, client) do
    request
    |> Request.to_options()
    |> then(&Tesla.request(client, &1))
  end

  @doc false
  def handle_response({:ok, %Tesla.Env{status: status} = env}, mapper) when status in 200..299 do
    {:ok, mapper.(env.body)}
  end

  def handle_response({:ok, %Tesla.Env{} = env}, _mapper) do
    {:error, Poison.Decode.transform(env.body, %{as: %Plaid.Error{}})}
  end

  def handle_response({:error, _reason} = error, _mapper) do
    error
  end
end
