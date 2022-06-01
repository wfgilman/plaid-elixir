defmodule Plaid.Utils do
  @moduledoc """
  Utility functions.
  """

  @type response :: %{required(String.t()) => any}
  @type endpoint :: atom

  @doc """
  Handles Plaid response and maps to the correct data structure.
  """
  @spec handle_resp({:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}, endpoint) ::
          {:ok, any} | {:error, Plaid.Error.t() | HTTPoison.Error.t()}
  def handle_resp({:ok, %HTTPoison.Response{status_code: code} = resp}, endpoint)
      when code in 200..201 do
    {:ok, map_response(resp.body, endpoint)}
  end

  def handle_resp({:ok, %HTTPoison.Response{} = resp}, _endpoint) do
    {:error, Poison.Decode.decode(resp.body, as: %Plaid.Error{})}
  end

  def handle_resp({:error, %HTTPoison.Error{} = error}, _endpoint) do
    {:error, error}
  end

  @doc """
  Maps an endpoint's response to the corresponding internal data structure.
  """
  @spec map_response(response, endpoint) :: any
  def map_response(response, :categories) do
    Poison.Decode.decode(response,
      as: %Plaid.Categories{
        categories: [
          %Plaid.Categories.Category{}
        ]
      }
    )
  end

  def map_response(response, :income) do
    Poison.Decode.decode(response,
      as: %Plaid.Income{
        item: %Plaid.Item{},
        income: %Plaid.Income.Income{
          income_streams: [
            %Plaid.Income.Income.IncomeStream{}
          ]
        }
      }
    )
  end

  def map_response(response, :institutions) do
    Poison.Decode.decode(response,
      as: %Plaid.Institutions{
        institutions: [
          %Plaid.Institutions.Institution{
            credentials: [%Plaid.Institutions.Institution.Credentials{}]
          }
        ]
      }
    )
  end

  def map_response(%{"institution" => institution} = response, :institution) do
    new_response = response |> Map.take(["request_id"]) |> Map.merge(institution)

    Poison.Decode.decode(new_response,
      as: %Plaid.Institutions.Institution{
        credentials: [%Plaid.Institutions.Institution.Credentials{}]
      }
    )
  end

  def map_response(response, :transactions) do
    Poison.Decode.decode(response,
      as: %Plaid.Transactions{
        accounts: [
          %Plaid.Accounts.Account{
            balances: %Plaid.Accounts.Account.Balance{}
          }
        ],
        transactions: [
          %Plaid.Transactions.Transaction{
            location: %Plaid.Transactions.Transaction.Location{},
            payment_meta: %Plaid.Transactions.Transaction.PaymentMeta{}
          }
        ],
        item: %Plaid.Item{}
      }
    )
  end

  def map_response(response, :accounts) do
    Poison.Decode.decode(response,
      as: %Plaid.Accounts{
        accounts: [
          %Plaid.Accounts.Account{balances: %Plaid.Accounts.Account.Balance{}}
        ],
        item: %Plaid.Item{}
      }
    )
  end

  def map_response(response, :auth) do
    Poison.Decode.decode(response,
      as: %Plaid.Auth{
        numbers: %Plaid.Auth.Numbers{
          ach: [%Plaid.Auth.Numbers.ACH{}]
        },
        item: %Plaid.Item{},
        accounts: [
          %Plaid.Accounts.Account{
            balances: %Plaid.Accounts.Account.Balance{}
          }
        ]
      }
    )
  end

  def map_response(response, :identity) do
    Poison.Decode.decode(response,
      as: %Plaid.Identity{
        item: %Plaid.Item{},
        accounts: [
          %Plaid.Accounts.Account{
            balances: %Plaid.Accounts.Account.Balance{},
            owners: [
              %Plaid.Accounts.Account.Owner{
                addresses: [%Plaid.Accounts.Account.Owner.Address{}],
                emails: [%Plaid.Accounts.Account.Owner.Email{}],
                phone_numbers: [%Plaid.Accounts.Account.Owner.PhoneNumber{}]
              }
            ]
          }
        ]
      }
    )
  end

  def map_response(%{"item" => item} = response, :item) do
    new_response = response |> Map.take(["request_id", "status"]) |> Map.merge(item)
    Poison.Decode.decode(new_response, as: %Plaid.Item{})
  end

  def map_response(%{"new_access_token" => _} = response, :item) do
    response
    |> Map.take(["new_access_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  def map_response(%{"access_token" => _} = response, :item) do
    response
    |> Map.take(["access_token", "item_id", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  def map_response(%{"public_token" => _} = response, :item) do
    response
    |> Map.take(["public_token", "expiration", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  def map_response(%{"deleted" => _} = response, :item) do
    response
    |> Map.take(["deleted", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  def map_response(%{"processor_token" => _} = response, :item) do
    response
    |> Map.take(["processor_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  def map_response(%{"stripe_bank_account_token" => _} = response, :item) do
    response
    |> Map.take(["stripe_bank_account_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  def map_response(response, :"investments/holdings") do
    Poison.Decode.decode(response,
      as: %Plaid.Investments.Holdings{
        accounts: [
          %Plaid.Accounts.Account{
            balances: %Plaid.Accounts.Account.Balance{}
          }
        ],
        securities: [%Plaid.Investments.Security{}],
        holdings: [%Plaid.Investments.Holdings.Holding{}],
        item: %Plaid.Item{}
      }
    )
  end

  def map_response(response, :"investments/transactions") do
    Poison.Decode.decode(response,
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
    )
  end

  def map_response(response, :link) do
    Poison.Decode.decode(response, %{
        as: %Plaid.Link{}
      }
    )
  end
end