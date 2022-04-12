defmodule Plaid.Investments.Transactions do
  @moduledoc """
  Functions for Plaid `investments/transactions` endpoints.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

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
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

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
  @spec get(params, config) :: {:ok, Plaid.Investments.Transactions.t()} | error
  def get(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "investments/transactions/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_investments_transactions(&1))
  end

  defp map_investments_transactions(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Investments.Transactions{
          accounts: [
            %Plaid.Accounts.Account{
              balances: %Plaid.Accounts.Account.Balance{}
            }
          ],
          securities: [%Plaid.Investments.Security{}],
          investment_transactions: [%Plaid.Investments.Transactions.Transaction{}],
          item: %Plaid.Item{}
        }
      }
    )
  end
end
