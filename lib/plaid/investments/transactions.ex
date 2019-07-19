defmodule Plaid.Investments.Transactions do
  @moduledoc """
  Functions for Plaid `investments/transactions` endpoints.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct accounts: [],
            item: nil,
            securities: [],
            investment_transactions: [],
            total_investment_transactions: nil,
            request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          securities: [Plaid.Investments.Security.t()],
          investment_transactions: [Plaid.Investments.Transactions.Transaction.t()],
          total_investment_transactions: integer,
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t() | map}
  @type config :: %{required(atom) => String.t()}

  @endpoint :"investments/transactions"

  defmodule Transaction do
    @moduledoc """
    Plaid Investments Transaction data structure.
    """

    @derive Jason.Encoder
    defstruct investment_transaction_id: nil,
              account_id: nil,
              security_id: nil,
              date: nil,
              name: nil,
              quantity: nil,
              amount: nil,
              price: nil,
              fees: nil,
              type: nil,
              iso_currency_code: nil,
              unofficial_currency_code: nil,
              cancel_transaction_id: nil

    @type t :: %__MODULE__{
            investment_transaction_id: String.t(),
            account_id: String.t(),
            security_id: String.t() | nil,
            date: String.t(),
            name: String.t(),
            quantity: float,
            amount: float,
            price: float,
            fees: float | nil,
            type: String.t(),
            iso_currency_code: String.t() | nil,
            unofficial_currency_code: String.t() | nil,
            cancel_transaction_id: String.t() | nil
          }
  end

  @doc """
  Gets user-authorized transaction data for investment accounts

  Parameters
  ```
   %{
    access_token: "access-env-identifier",
    start_date: "2017-01-01",
    end_date: "2017-03-31",
    options: %{
      account_ids: ["BFEWTGFD"],
      count: 20,
      offset: 0
    }
  }
  ```
  """
  @spec get(params, config | nil) ::
          {:ok, Plaid.Investments.Tansactions.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
