defmodule Plaid.Item do
  @moduledoc """
  Functions for Plaid `Item` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0]

  alias Plaid.Utils

  defstruct available_products: [], billed_products: [], error: nil,
            institution_id: nil, item_id: nil, webhook: nil, request_id: nil

  @type t :: %__MODULE__{available_products: [String.t],
                         billed_products: [String.t],
                         error: String.t,
                         institution_id: String.t,
                         item_id: String.t,
                         webhook: String.t,
                         request_id: String.t
                        }

  @endpoint "item"

  @doc """
  Gets an Item.

  `params = %{access_token: "access-env-identifier"}`
  """
  @spec get(map, map | nil) :: {:ok, Plaid.Item.t} | {:error, Plaid.Error.t}
  def get(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/get"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

  @doc """
  Exchanges a public token for an access token and item_id.

  `params = %{public_token: "public-env-identifier"}`
  """
  @spec exchange_public_token(map, map | nil) ::
    {:ok, map} | {:error, Plaid.Error.t}
  def exchange_public_token(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/public_token/exchange"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

  @doc """
  Creates a public token. To be used to put Plaid Link into update mode.

  `params = %{access_token: "access-env-identifier"}`
  """
  @spec create_public_token(map, map | nil) ::
    {:ok, map} | {:error, Plaid.Error.t}
  def create_public_token(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/public_token/create"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

  @doc """
  Updates an Item's webhook.

  `params = %{access_webhook: "access-env-identifier", webhook: "http://mywebsite/api"}`
  """
  @spec update_webhook(map, map | nil) ::
    {:ok, Plaid.Item.t} | {:error, Plaid.Error.t}
  def update_webhook(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/webhook/update"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

  @doc """
  Invalidates access token and returns a new one.

  `params = %{access_token: "access-env-identifier"}`
  """
  @spec rotate_access_token(map, map | nil) ::
    {:ok, map} | {:error, Plaid.Error.t}
  def rotate_access_token(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/access_token/invalidate"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

  @doc """
  Updates a V1 access token to V2.

  `params = %{access_token_v1: "test_wells"}`
  """
  @spec update_version_access_token(map, map | nil) ::
    {:ok, map} | {:error, Plaid.Error.t}
  def update_version_access_token(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/access_token/update_version"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

  @doc """
  Deletes an Item.

  `params = %{access_token: "access-env-identifier"}`
  """
  @spec delete(map, map | nil) :: {:ok, map} | {:error, Plaid.Error.t}
  def delete(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/delete"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

  @doc """
  Creates a processor token used to create an authenticated funding source with Dwolla.

  `params = %{access_token: "access-env-identifier", account_id: "plaid-account-id"}`
  """
  @spec create_processor_token(map, map | nil) :: {:ok, map} | {:error, Plaid.Error.t}
  def create_processor_token(params, cred \\ get_cred()) do
    endpoint = "processor/dwolla/processor_token/create"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:item)
  end

end
