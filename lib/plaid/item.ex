defmodule Plaid.Item do
  @moduledoc """
  Functions for Plaid `item` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct available_products: [],
            billed_products: [],
            error: nil,
            institution_id: nil,
            item_id: nil,
            webhook: nil,
            request_id: nil

  @type t :: %__MODULE__{
          available_products: [String.t()],
          billed_products: [String.t()],
          error: String.t(),
          institution_id: String.t(),
          item_id: String.t(),
          webhook: String.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t()}
  @type config :: %{required(atom) => String.t()}

  @endpoint :item

  @doc """
  Gets an Item.

  Parameters
  ```
  %{access_token: "access-env-identifier"}
  ```
  """
  @spec get(params, config | nil) :: {:ok, Plaid.Item.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Exchanges a public token for an access token and item id.

  Parameters
  ```
  %{public_token: "public-env-identifier"}
  ```

  Response
  ```
  {:ok, %{access_token: "access-env-identifier", item_id: "some-id", request_id: "f24wfg"}}
  ```
  """
  @spec exchange_public_token(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def exchange_public_token(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/public_token/exchange"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Creates a public token. To be used to put Plaid Link into update mode.

  Parameters
  ```
  %{access_token: "access-env-identifier"}
  ```

  Response
  ```
  {:ok, %{public_token: "access-env-identifier", expiration: 3600, request_id: "kg414f"}}
  ```
  """
  @spec create_public_token(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def create_public_token(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/public_token/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Updates an Item's webhook.

  Parameters
  ```
  %{access_webhook: "access-env-identifier", webhook: "http://mywebsite/api"}
  ```
  """
  @spec update_webhook(params, config | nil) :: {:ok, Plaid.Item.t()} | {:error, Plaid.Error.t()}
  def update_webhook(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/webhook/update"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Invalidates access token and returns a new one.

  Parameters
  ```
  %{access_token: "access-env-identifier"}
  ```

  Response
  ```
  {:ok, %{new_access_token: "access-env-identifier", request_id: "gag8fs"}}
  ```
  """
  @spec rotate_access_token(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def rotate_access_token(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/access_token/invalidate"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Updates a V1 access token to V2.

  Parameters
  ```
  %{access_token_v1: "test_wells"}
  ```

  Response
  ```
  {:ok, %{access_token: "access-env-identifier", item_id: "some-id", request_id: "f24wfg"}}
  ```
  """
  @spec update_version_access_token(params, config | nil) ::
          {:ok, map} | {:error, Plaid.Error.t()}
  def update_version_access_token(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/access_token/update_version"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Deletes an Item.

  Parameters
  ```
  %{access_token: "access-env-identifier"}
  ```
  """
  @spec delete(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def delete(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/delete"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  [Creates a processor token](https://developers.dwolla.com/resources/dwolla-plaid-integration.html)
  used to create an authenticated funding source with Dwolla.

  Parameters
  ```
  %{access_token: "access-env-identifier", account_id: "plaid-account-id"}
  ```

  Response
  ```
  {:ok, %{processor_token: "some-token", request_id: "k522f2"}}
  ```
  """
  @spec create_processor_token(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def create_processor_token(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "processor/dwolla/processor_token/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
