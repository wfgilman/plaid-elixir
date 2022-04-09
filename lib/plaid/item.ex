defmodule Plaid.Item do
  @moduledoc """
  Functions for Plaid `item` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct available_products: [],
            billed_products: [],
            error: nil,
            institution_id: nil,
            item_id: nil,
            webhook: nil,
            consent_expiration_time: nil,
            request_id: nil,
            status: nil

  @type t :: %__MODULE__{
          available_products: [String.t()],
          billed_products: [String.t()],
          error: String.t() | nil,
          institution_id: String.t(),
          item_id: String.t(),
          webhook: String.t(),
          consent_expiration_time: String.t(),
          request_id: String.t(),
          status: Plaid.Item.Status.t()
        }
  @type params :: %{required(atom) => String.t() | [String.t()] | map}
  @type config :: %{required(atom) => String.t()}
  @type service :: :dwolla | :modern_treasury | :svb_api

  @endpoint :item

  defmodule Status do
    @moduledoc """
    Plaid Item Status data structure.
    """

    @derive Jason.Encoder
    defstruct investments: nil,
              transactions: nil,
              last_webhook: nil

    @type t :: %__MODULE__{
            investments: Plaid.Item.Status.Investments.t(),
            transactions: Plaid.Item.Status.Transactions.t(),
            last_webhook: Plaid.Item.Status.LastWebhook.t()
          }

    defmodule Investments do
      @moduledoc """
      Plaid Item Status Investments data structure.
      """

      @derive Jason.Encoder
      defstruct last_successful_update: nil, last_failed_update: nil
      @type t :: %__MODULE__{last_successful_update: String.t(), last_failed_update: String.t()}
    end

    defmodule Transactions do
      @moduledoc """
      Plaid Item Status Transactions data structure.
      """

      @derive Jason.Encoder
      defstruct last_successful_update: nil, last_failed_update: nil
      @type t :: %__MODULE__{last_successful_update: String.t(), last_failed_update: String.t()}
    end

    defmodule LastWebhook do
      @moduledoc """
      Plaid Item Status LastWebhook data structure.
      """

      @derive Jason.Encoder
      defstruct sent_at: nil, code_sent: nil
      @type t :: %__MODULE__{sent_at: String.t(), code_sent: String.t()}
    end
  end

  @doc """
  Gets an Item.

  Parameters
  ```
  %{access_token: "access-env-identifier"}
  ```
  """
  @spec get(params, config | nil) :: {:ok, Plaid.Item.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = validate_cred(config)
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
    config = validate_cred(config)
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
    config = validate_cred(config)
    endpoint = "#{@endpoint}/public_token/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Updates an Item's webhook.

  Parameters
  ```
  %{access_token: "access-env-identifier", webhook: "http://mywebsite/api"}
  ```
  """
  @spec update_webhook(params, config | nil) :: {:ok, Plaid.Item.t()} | {:error, Plaid.Error.t()}
  def update_webhook(params, config \\ %{}) do
    config = validate_cred(config)
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
    config = validate_cred(config)
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
    config = validate_cred(config)
    endpoint = "#{@endpoint}/access_token/update_version"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Removes an Item.

  Parameters
  ```
  %{access_token: "access-env-identifier"}
  ```

  Response
  ```
  {:ok, %{request_id: "[Unique request ID]"}}
  ```
  """
  @spec remove(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def remove(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/remove"

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
  @deprecated "Use create_processor_token/3 instead"
  @spec create_processor_token(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def create_processor_token(params, config \\ %{}) do
    create_processor_token(params, :dwolla, config)
  end

  @doc """
  Creates a processor token used to integrate with services external to Plaid.

  Parameters
  ```
  %{access_token: "access-env-identifier", account_id: "plaid-account-id"}
  ```

  Response
  ```
  {:ok, %{processor_token: "some-token", request_id: "k522f2"}}
  ```
  """
  @spec create_processor_token(params, service, config | nil) ::
          {:ok, map} | {:error, Plaid.Error.t()}
  def create_processor_token(params, service, config) do
    config = validate_cred(config)
    endpoint = "processor/token/create"
    param_with_processor = Map.put(params, :processor, service)

    make_request_with_cred(:post, endpoint, config, param_with_processor)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  [Creates a stripe bank account token](https://stripe.com/docs/ach)
  used to create an authenticated funding source with Stripe.

  Parameters
  ```
  %{access_token: "access-env-identifier", account_id: "plaid-account-id"}
  ```

  Response
  ```
  {:ok, %{stripe_bank_account_token: "btok_Kb62HbBqrrvdf8pBsAdt", request_id: "[Unique request ID]"}}
  ```
  """
  @spec create_stripe_bank_account_token(params, config | nil) ::
          {:ok, map} | {:error, Plaid.Error.t()}
  def create_stripe_bank_account_token(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "processor/stripe/bank_account_token/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
