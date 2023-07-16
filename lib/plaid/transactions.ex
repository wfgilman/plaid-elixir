defmodule Plaid.Transactions do
  @moduledoc """
  Functions for Plaid `transactions` endpoint.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, total_transactions: nil, transactions: [], request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          total_transactions: integer,
          transactions: [Plaid.Transactions.Transaction.t()],
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

  defmodule Sync do
    @moduledoc """
    Data structure for transactions/sync API
    """

    @derive Jason.Encoder
    defstruct added: [],
              has_more: nil,
              modified: [],
              next_cursor: nil,
              removed: [],
              request_id: nil

    @type t :: %__MODULE__{
            added: [Plaid.Transactions.Transaction.t()],
            has_more: boolean(),
            modified: [Plaid.Transactions.Transaction.t()],
            next_cursor: String.t(),
            removed: [Plaid.Transactions.RemovedTransaction.t()],
            request_id: String.t()
          }
  end

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
              transaction_code: nil,
              check_number: nil,
              personal_finance_category: nil

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
            pending: boolean(),
            pending_transaction_id: String.t(),
            transaction_id: String.t(),
            transaction_type: String.t(),
            merchant_name: String.t(),
            authorized_date: String.t(),
            payment_channel: String.t(),
            transaction_code: String.t(),
            personal_finance_category: Plaid.Transactions.Transaction.PersonalFinanceCategory.t()
          }

    defmodule Location do
      @moduledoc """
      Plaid Transaction Location data structure.
      """

      @derive Jason.Encoder
      defstruct address: nil,
                city: nil,
                # Deprecated, use :region instead.
                state: nil,
                # Deprecated, use :postal_code instead.
                zip: nil,
                region: nil,
                postal_code: nil,
                country: nil,
                lat: nil,
                lon: nil,
                store_number: nil

      @type t :: %__MODULE__{
              address: String.t(),
              city: String.t(),
              state: String.t(),
              zip: String.t(),
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

    defmodule PersonalFinanceCategory do
      @moduledoc """
      Plaid Transaction Personal Finance Category data structure.
      """

      @derive Jason.Encoder
      defstruct primary: nil,
                detailed: nil

      @type t :: %__MODULE__{
              primary: String.t(),
              detailed: String.t()
            }
    end
  end

  defmodule RemovedTransaction do
    @moduledoc """
    Removed transaction data structure
    """

    @derive Jason.Encoder
    defstruct transaction_id: nil

    @type t :: %__MODULE__{
            transaction_id: String.t()
          }
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
  @spec get(params, config) :: {:ok, Plaid.Transactions.t()} | error
  def get(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "transactions/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_transactions(&1))
  end

  defp map_transactions(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Transactions{
          accounts: [
            %Plaid.Accounts.Account{
              balances: %Plaid.Accounts.Account.Balance{}
            }
          ],
          transactions: [
            %Plaid.Transactions.Transaction{
              location: %Plaid.Transactions.Transaction.Location{},
              payment_meta: %Plaid.Transactions.Transaction.PaymentMeta{},
              personal_finance_category: %Plaid.Transactions.Transaction.PersonalFinanceCategory{}
            }
          ],
          item: %Plaid.Item{}
        }
      }
    )
  end

  @doc """
  Sync transactions data associated with an Item.

  Parameters
  ```
  %{
    access_token: "access-env-identifier",
    count: 20,
    cursor: "last-request-cursor-value"
  }
  ```
  """
  @spec sync(params, config) :: {:ok, Plaid.Transactions.Sync.t()} | error
  def sync(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "transactions/sync", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_sync_transactions(&1))
  end

  defp map_sync_transactions(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Transactions.Sync{
          added: [
            %Plaid.Transactions.Transaction{
              location: %Plaid.Transactions.Transaction.Location{},
              payment_meta: %Plaid.Transactions.Transaction.PaymentMeta{},
              personal_finance_category: %Plaid.Transactions.Transaction.PersonalFinanceCategory{}
            }
          ],
          modified: [
            %Plaid.Transactions.Transaction{
              location: %Plaid.Transactions.Transaction.Location{},
              payment_meta: %Plaid.Transactions.Transaction.PaymentMeta{},
              personal_finance_category: %Plaid.Transactions.Transaction.PersonalFinanceCategory{}
            }
          ],
          removed: [
            %Plaid.Transactions.RemovedTransaction{}
          ]
        }
      }
    )
  end
end
