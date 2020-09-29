defmodule Plaid.Transactions do
  @moduledoc """
  Functions for Plaid `transactions` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, total_transactions: nil, transactions: [], request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          total_transactions: integer,
          transactions: [Plaid.Transactions.Transaction.t()],
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t() | map}
  @type config :: %{required(atom) => String.t()}

  @endpoint :transactions

  defmodule Transaction do
    @moduledoc """
    Plaid Transaction data structure.
    """

    @derive Jason.Encoder
    defstruct account_id: nil,
              account_owner: nil,
              amount: nil,
              iso_currency_code: nil,
              unofficial_currency_code: nil,
              category: nil,
              category_id: nil,
              date: nil,
              location: nil,
              name: nil,
              payment_meta: nil,
              pending: false,
              pending_transaction_id: nil,
              transaction_id: nil,
              transaction_type: nil,
              merchant_name: nil,
              authorized_date: nil,
              payment_channel: nil,
              transaction_code: nil

    @type t :: %__MODULE__{
            account_id: String.t(),
            account_owner: String.t(),
            amount: float,
            iso_currency_code: String.t(),
            unofficial_currency_code: String.t(),
            category: [String.t()],
            category_id: String.t(),
            date: String.t(),
            location: Plaid.Transactions.Transaction.Location.t(),
            name: String.t(),
            payment_meta: Plaid.Transactions.Transaction.PaymentMeta.t(),
            pending: true | false,
            pending_transaction_id: String.t(),
            transaction_id: String.t(),
            transaction_type: String.t(),
            merchant_name: String.t(),
            authorized_date: String.t(),
            payment_channel: String.t(),
            transaction_code: String.t()
          }

    defmodule Location do
      @moduledoc """
      Plaid Transaction Location data structure.
      """

      @derive Jason.Encoder
      defstruct address: nil,
                city: nil,
                region: nil,
                postal_code: nil,
                country: nil,
                lat: nil,
                lon: nil,
                store_number: nil

      @type t :: %__MODULE__{
              address: String.t(),
              city: String.t(),
              region: String.t(),
              postal_code: String.t(),
              country: String.t(),
              lat: float,
              lon: float,
              store_number: integer
            }
    end

    defmodule PaymentMeta do
      @moduledoc """
      Plaid Transaction Payment Metadata data structure.
      """

      @derive Jason.Encoder
      defstruct by_order_of: nil,
                payee: nil,
                payer: nil,
                payment_method: nil,
                payment_processor: nil,
                ppd_id: nil,
                reason: nil,
                reference_number: nil

      @type t :: %__MODULE__{
              by_order_of: String.t(),
              payee: String.t(),
              payer: String.t(),
              payment_method: String.t(),
              payment_processor: String.t(),
              ppd_id: String.t(),
              reason: String.t(),
              reference_number: String.t()
            }
    end
  end

  @doc """
  Gets transactions data associated with an Item.

  Parameters
  ```
  %{
    access_token: "access-env-identifier",
    start_date: "2017-01-01",
    end_date: "2017-03-31",
    options: %{
      count: 20,
      offset: 0
    }
  }
  ```
  """
  @spec get(params, config | nil) :: {:ok, Plaid.Transactions.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
