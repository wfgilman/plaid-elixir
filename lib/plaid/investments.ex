defmodule Plaid.Investments do
  defmodule Security do
    @moduledoc """
    Plaid Investments Security data structure.
    """

    @derive Jason.Encoder
    defstruct security_id: nil,
              isin: nil,
              sedol: nil,
              cusip: nil,
              institution_security_id: nil,
              institution_id: nil,
              proxy_security_id: nil,
              ticker_symbol: nil,
              name: nil,
              is_cash_equivalent: false,
              type: nil,
              close_price: nil,
              close_price_as_of: nil,
              iso_currency_code: nil,
              unofficial_currency_code: nil

    @type t :: %__MODULE__{
            security_id: String.t(),
            isin: String.t() | nil,
            sedol: String.t() | nil,
            cusip: String.t() | nil,
            institution_security_id: String.t() | nil,
            institution_id: String.t() | nil,
            proxy_security_id: String.t() | nil,
            ticker_symbol: String.t() | nil,
            name: String.t() | nil,
            is_cash_equivalent: true | false,
            type: String.t(),
            close_price: float,
            close_price_as_of: String.t(),
            iso_currency_code: String.t() | nil,
            unofficial_currency_code: String.t() | nil
          }
  end

  defmodule Holdings do
    @moduledoc """
    Functions for Plaid `investments/holdings` endpoints.
    """

    import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

    alias Plaid.Utils

    @type params :: %{required(atom) => String.t() | map}
    @type config :: %{required(atom) => String.t()}

    @endpoint :"investments/holdings"

    @derive Jason.Encoder
    defstruct accounts: [], item: nil, securities: [], holdings: [], request_id: nil

    @type t :: %__MODULE__{
            accounts: [Plaid.Accounts.Account.t()],
            item: Plaid.Item.t(),
            securities: [Plaid.Investments.Security.t()],
            holdings: [Plaid.Investments.Holdings.Holding.t()],
            request_id: String.t()
          }

    defmodule Holding do
      @moduledoc """
      Plaid Investments Holding data structure.
      """

      @derive Jason.Encoder
      defstruct account_id: nil,
                security_id: nil,
                institution_price: nil,
                institution_price_as_of: nil,
                institution_value: nil,
                cost_basis: nil,
                quantity: nil,
                iso_currency_code: nil,
                unofficial_currency_code: nil

      @type t :: %__MODULE__{
              account_id: String.t(),
              security_id: String.t(),
              institution_price: float,
              institution_price_as_of: String.t() | nil,
              institution_value: float,
              cost_basis: float | nil,
              quantity: float,
              iso_currency_code: String.t() | nil,
              unofficial_currency_code: String.t() | nil
            }
    end

    @doc """
    Gets user-authorized stock position data for investment-type Accounts

    Parameters
    ```
    %{
      access_token: "access-env-identifier",
      options: %{
        account_ids: ["BFEWTGFD"]
      }
    }
    ```
    """
    @spec get(params, config | nil) ::
            {:ok, Plaid.Investments.Holdings.t()} | {:error, Plaid.Error.t()}
    def get(params, config \\ %{}) do
      config = validate_cred(config)
      endpoint = "#{@endpoint}/get"

      make_request_with_cred(:post, endpoint, config, params)
      |> Utils.handle_resp(@endpoint)
    end
  end

  defmodule Transactions do
    @moduledoc """
    Functions for Plaid `investments/transactions` endpoints.
    """

    import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

    alias Plaid.Utils

    @type params :: %{required(atom) => String.t() | map}
    @type config :: %{required(atom) => String.t()}

    @endpoint :"investments/transactions"

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

    defmodule Transaction do
      @moduledoc """
      Plaid Investments Transaction data structure.
      """

      @derive Jason.Encoder
      defstruct transaction_id: nil,
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
              transaction_id: String.t(),
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
end
