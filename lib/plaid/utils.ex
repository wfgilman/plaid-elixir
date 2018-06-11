defmodule Plaid.Utils do
  @moduledoc """
  Utility functions.
  """

  @doc """
  Handles Plaid response and maps to the correct data structure.
  """
  def handle_resp({:ok, %{status_code: code} = resp}, schema) when code in 200..201 do
     {:ok, map_body(resp.body, schema)}
  end
  def handle_resp({:ok, resp}, _schema) do
    {:error, Poison.Decode.decode(resp.body, as: %Plaid.Error{})}
  end
  def handle_resp({:error, %HTTPoison.Error{} = error}, _schema) do
    {:error, error}
  end

  def map_body(body, :categories) do
    Poison.Decode.decode(body, as: %Plaid.Categories{categories: [
      %Plaid.Categories.Category{}
     ]})
  end
  def map_body(body, :institutions) do
    Poison.Decode.decode(body, as: %Plaid.Institutions{institutions: [
      %Plaid.Institutions.Institution{
        credentials: [%Plaid.Institutions.Institution.Credentials{}]
      }
    ]})
  end
  def map_body(%{"institution" => institution} = body, :institution) do
    new_body = body |> Map.take(["request_id"]) |> Map.merge(institution)
    Poison.Decode.decode(new_body, as: %Plaid.Institutions.Institution{
      credentials: [%Plaid.Institutions.Institution.Credentials{}]
    })
  end
  def map_body(body, :transactions) do
    Poison.Decode.decode(body, as: %Plaid.Transactions{
      accounts: [%Plaid.Accounts.Account{
        balances: %Plaid.Accounts.Account.Balance{}
      }],
      transactions: [%Plaid.Transactions.Transaction{
        location: %Plaid.Transactions.Transaction.Location{},
        payment_meta: %Plaid.Transactions.Transaction.PaymentMeta{}
      }],
      item: %Plaid.Item{}
    })
  end
  def map_body(body, :accounts) do
    Poison.Decode.decode(body, as: %Plaid.Accounts{
      accounts: [
        %Plaid.Accounts.Account{balances: %Plaid.Accounts.Account.Balance{}}
      ],
      item: %Plaid.Item{}
    })
  end
  def map_body(%{"item" => item} = body, :item) do
    new_body = body |> Map.take(["request_id"]) |> Map.merge(item)
    Poison.Decode.decode(new_body, as: %Plaid.Item{})
  end
  def map_body(%{"new_access_token" => _} = body, :item) do
    body
    |> Map.take(["new_access_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
          Map.put(acc, String.to_atom(k), v)
       end)
  end
  def map_body(%{"access_token" => _} = body, :item) do
    body
    |> Map.take(["access_token", "item_id", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
         Map.put(acc, String.to_atom(k), v)
       end)
  end
  def map_body(%{"public_token" => _} = body, :item) do
    body
    |> Map.take(["public_token", "expiration", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
         Map.put(acc, String.to_atom(k), v)
       end)
  end
  def map_body(%{"deleted" => _} = body, :item) do
    body
    |> Map.take(["deleted", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
         Map.put(acc, String.to_atom(k), v)
       end)
  end
  def map_body(%{"processor_token" => _} = body, :item) do
    body
    |> Map.take(["processor_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
        Map.put(acc, String.to_atom(k), v)
      end)
  end
end
