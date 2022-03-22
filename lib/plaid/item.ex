defmodule Plaid.Item do
  @moduledoc """
  Functions for Plaid `item` endpoint.
  """

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
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | Plaid.HTTPClient.Error.t()} | no_return

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
  @spec get(params, config) :: {:ok, Plaid.Item.t()} | error
  def get(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/get", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec exchange_public_token(params, config) :: {:ok, map} | error
  def exchange_public_token(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/public_token/exchange", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec create_public_token(params, config) :: {:ok, map} | error
  def create_public_token(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/public_token/create", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end

  @doc """
  Updates an Item's webhook.

  Parameters
  ```
  %{access_token: "access-env-identifier", webhook: "http://mywebsite/api"}
  ```
  """
  @spec update_webhook(params, config) :: {:ok, Plaid.Item.t()} | error
  def update_webhook(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/webhook/update", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec rotate_access_token(params, config) :: {:ok, map} | error
  def rotate_access_token(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/access_token/invalidate", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec update_version_access_token(params, config) :: {:ok, map} | error
  def update_version_access_token(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/access_token/update_version", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec remove(params, config) :: {:ok, map} | error
  def remove(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/remove", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end

  @doc """
  [Creates a processor token](https://plaid.com/docs/api/processors)
  used to integrate with services external to Plaid.

  Parameters
  ```
  %{
    access_token: "access-env-identifier",
    account_id: "plaid-account-id",
    processor: "dwolla"
  }
  ```

  Response
  ```
  {:ok, %{processor_token: "some-token", request_id: "k522f2"}}
  ```
  """
  @spec create_processor_token(params, config) :: {:ok, map} | error
  def create_processor_token(params, config) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("processor/token/create", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec create_stripe_bank_account_token(params, config) :: {:ok, map} | error
  def create_stripe_bank_account_token(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("processor/stripe/bank_account_token/create", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end
end
