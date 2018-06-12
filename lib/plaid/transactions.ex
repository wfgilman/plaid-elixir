defmodule Plaid.Transactions do
  @moduledoc """
  Functions for Plaid `transactions` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0]

  alias Plaid.Utils

  defstruct accounts: [], item: nil, total_transactions: nil, transactions: []

  @type t :: %__MODULE__{accounts: [Plaid.Accounts.Account.t],
                         item: Plaid.Item.t,
                         total_transactions: integer,
                         transactions: [Plaid.Transactions.Transaction.t]}

  @endpoint "transactions"

  defmodule Transaction do

    defstruct account_id: nil, account_owner: nil, amount: nil, category: nil,
              category_id: nil, date: nil, location: nil, name: nil,
              payment_meta: nil, pending: false, pending_transaction_id: nil,
              transaction_id: nil, transaction_type: nil
    @type t :: %__MODULE__{account_id: String.t,
                           account_owner: String.t,
                           amount: float,
                           category: [String.t],
                           category_id: String.t,
                           date: String.t,
                           location: Plaid.Transactions.Transaction.Location.t,
                           name: String.t,
                           payment_meta: Plaid.Transactions.Transaction.PaymentMeta.t,
                           pending: true | false,
                           pending_transaction_id: String.t,
                           transaction_id: String.t,
                           transaction_type: String.t
                          }

    defmodule Location do

      defstruct address: nil, city: nil, state: nil, zip: nil, lat: nil, lon: nil
      @type t :: %__MODULE__{address: String.t,
                             city: String.t,
                             state: String.t,
                             zip: String.t,
                             lat: float,
                             lon: float
                            }
    end

    defmodule PaymentMeta do

      defstruct by_order_of: nil, payee: nil, payer: nil, payment_method: nil,
                payment_processor: nil, ppd_id: nil, reason: nil,
                reference_number: nil
      @type t :: %__MODULE__{by_order_of: String.t,
                             payee: String.t,
                             payer: String.t,
                             payment_method: String.t,
                             payment_processor: String.t,
                             ppd_id: String.t,
                             reason: String.t,
                             reference_number: String.t
                            }
    end
  end

  @doc """
  Gets transactions data associated with an Item.
  ```
  params = %{access_token: "access-env-identifier", start_date: "2017-01-01",
             end_date: "2017-03-31", options: %{count: 20, offset: 0}}
  ```
  """
  @spec get(map, map | nil) :: {:ok, Plaid.Transactions.t} | {:error, Plaid.Error.t}
  def get(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/get"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:transactions)
  end

end
