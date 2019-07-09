defmodule Plaid.Investments.Security do
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
