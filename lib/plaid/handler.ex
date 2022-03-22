defmodule Plaid.Handler do
  @moduledoc """
  Maps external responses from Plaid's API to internal data structures.
  """

  @type endpoint :: atom

  @doc """
  Handles Plaid response and maps to the correct data structure.
  """
  @spec handle_resp({:ok, PlaidHTTP.Response.t()} | {:error, PlaidHTTP.Error.t()}, endpoint) ::
          {:ok, term} | {:error, Plaid.Error.t() | PlaidHTTP.Error.t()} | no_return
  def handle_resp({:ok, %PlaidHTTP.Response{body: body}}, _endpoint) when not is_map(body) do
    raise PlaidHTTP.Error,
      message: """
        PlaidHTTP.call/5 must return a PlaidHTTP.Response struct with a map data type
        for the key :body.

        Value for :body was #{inspect(body)}
      """
  end

  def handle_resp({:ok, %PlaidHTTP.Response{status_code: code, body: body}}, endpoint)
      when code in 200..299 do
    {:ok, map_response(body, endpoint)}
  end

  def handle_resp({:ok, %PlaidHTTP.Response{body: body}}, _endpoint) do
    {:error, Poison.Decode.transform(body, %{as: %Plaid.Error{}})}
  end

  def handle_resp({:error, %PlaidHTTP.Error{} = error}, _endpoint) do
    {:error, error}
  end

  defp map_response(response, :categories) do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.Categories{
          categories: [
            %Plaid.Categories.Category{}
          ]
        }
      }
    )
  end

  defp map_response(response, :income) do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.Income{
          item: %Plaid.Item{},
          income: %Plaid.Income.Income{
            income_streams: [
              %Plaid.Income.Income.IncomeStream{}
            ]
          }
        }
      }
    )
  end

  defp map_response(response, :institutions) do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.Institutions{
          institutions: [
            %Plaid.Institutions.Institution{
              credentials: [%Plaid.Institutions.Institution.Credentials{}],
              status: %Plaid.Institutions.Institution.Status{
                item_logins: %Plaid.Institutions.Institution.Status.ItemLogins{
                  breakdown: %Plaid.Institutions.Institution.Status.ItemLogins.Breakdown{}
                },
                transactions_updates: %Plaid.Institutions.Institution.Status.TransactionsUpdates{
                  breakdown:
                    %Plaid.Institutions.Institution.Status.TransactionsUpdates.Breakdown{}
                },
                auth: %Plaid.Institutions.Institution.Status.Auth{
                  breakdown: %Plaid.Institutions.Institution.Status.Auth.Breakdown{}
                },
                balance: %Plaid.Institutions.Institution.Status.Balance{
                  breakdown: %Plaid.Institutions.Institution.Status.Balance.Breakdown{}
                },
                identity: %Plaid.Institutions.Institution.Status.Identity{
                  breakdown: %Plaid.Institutions.Institution.Status.Identity.Breakdown{}
                }
              }
            }
          ]
        }
      }
    )
  end

  defp map_response(%{"institution" => institution} = response, :institution) do
    new_response = response |> Map.take(["request_id"]) |> Map.merge(institution)

    Poison.Decode.transform(
      new_response,
      %{
        as: %Plaid.Institutions.Institution{
          credentials: [%Plaid.Institutions.Institution.Credentials{}],
          status: %Plaid.Institutions.Institution.Status{
            item_logins: %Plaid.Institutions.Institution.Status.ItemLogins{
              breakdown: %Plaid.Institutions.Institution.Status.ItemLogins.Breakdown{}
            },
            transactions_updates: %Plaid.Institutions.Institution.Status.TransactionsUpdates{
              breakdown: %Plaid.Institutions.Institution.Status.TransactionsUpdates.Breakdown{}
            },
            auth: %Plaid.Institutions.Institution.Status.Auth{
              breakdown: %Plaid.Institutions.Institution.Status.Auth.Breakdown{}
            },
            balance: %Plaid.Institutions.Institution.Status.Balance{
              breakdown: %Plaid.Institutions.Institution.Status.Balance.Breakdown{}
            },
            identity: %Plaid.Institutions.Institution.Status.Identity{
              breakdown: %Plaid.Institutions.Institution.Status.Identity.Breakdown{}
            }
          }
        }
      }
    )
  end

  defp map_response(response, :transactions) do
    Poison.Decode.transform(
      response,
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
              payment_meta: %Plaid.Transactions.Transaction.PaymentMeta{}
            }
          ],
          item: %Plaid.Item{}
        }
      }
    )
  end

  defp map_response(response, :accounts) do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.Accounts{
          accounts: [
            %Plaid.Accounts.Account{balances: %Plaid.Accounts.Account.Balance{}}
          ],
          item: %Plaid.Item{}
        }
      }
    )
  end

  defp map_response(response, :auth) do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.Auth{
          numbers: %Plaid.Auth.Numbers{
            ach: [%Plaid.Auth.Numbers.ACH{}],
            eft: [%Plaid.Auth.Numbers.EFT{}],
            international: [%Plaid.Auth.Numbers.International{}],
            bacs: [%Plaid.Auth.Numbers.BACS{}]
          },
          item: %Plaid.Item{},
          accounts: [
            %Plaid.Accounts.Account{
              balances: %Plaid.Accounts.Account.Balance{}
            }
          ]
        }
      }
    )
  end

  defp map_response(response, :identity) do
    Poison.Decode.transform(
      response,
      %{
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
      }
    )
  end

  defp map_response(%{"item" => item} = response, :item) do
    new_response = response |> Map.take(["request_id", "status"]) |> Map.merge(item)

    Poison.Decode.transform(
      new_response,
      %{
        as: %Plaid.Item{
          status: %Plaid.Item.Status{
            investments: %Plaid.Item.Status.Investments{},
            transactions: %Plaid.Item.Status.Transactions{},
            last_webhook: %Plaid.Item.Status.LastWebhook{}
          }
        }
      }
    )
  end

  defp map_response(%{"new_access_token" => _} = response, :item) do
    response
    |> Map.take(["new_access_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  defp map_response(%{"access_token" => _} = response, :item) do
    response
    |> Map.take(["access_token", "item_id", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  defp map_response(%{"public_token" => _} = response, :item) do
    response
    |> Map.take(["public_token", "expiration", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  defp map_response(%{"processor_token" => _} = response, :item) do
    response
    |> Map.take(["processor_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  defp map_response(%{"stripe_bank_account_token" => _} = response, :item) do
    response
    |> Map.take(["stripe_bank_account_token", "request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  defp map_response(%{"request_id" => _} = response, :item) do
    response
    |> Map.take(["request_id"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end

  defp map_response(response, :"investments/holdings") do
    Poison.Decode.transform(
      response,
      %{
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
      }
    )
  end

  defp map_response(response, :"investments/transactions") do
    Poison.Decode.transform(
      response,
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

  defp map_response(response, :link) do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.Link{metadata: %Plaid.Link.Metadata{}}
      }
    )
  end

  defp map_response(response, :webhook_verification_key) do
    Poison.Decode.transform(response, %{as: %Plaid.WebhookVerificationKey{}})
  end

  defp map_response(%{"payments" => _} = response, :"payment_initiation/payment") do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.PaymentInitiation.Payments{
          payments: [
            %Plaid.PaymentInitiation.Payments.Payment{
              amount: %Plaid.PaymentInitiation.Payments.Payment.Amount{},
              schedule: %Plaid.PaymentInitiation.Payments.Payment.Schedule{}
            }
          ]
        }
      }
    )
  end

  defp map_response(response, :"payment_initiation/payment") do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.PaymentInitiation.Payments.Payment{
          amount: %Plaid.PaymentInitiation.Payments.Payment.Amount{},
          schedule: %Plaid.PaymentInitiation.Payments.Payment.Schedule{}
        }
      }
    )
  end

  defp map_response(%{"recipients" => _} = response, :"payment_initiation/recipient") do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.PaymentInitiation.Recipients{
          recipients: [
            %Plaid.PaymentInitiation.Recipients.Recipient{
              address: %Plaid.PaymentInitiation.Recipients.Recipient.Address{}
            }
          ]
        }
      }
    )
  end

  defp map_response(response, :"payment_initiation/recipient") do
    Poison.Decode.transform(
      response,
      %{
        as: %Plaid.PaymentInitiation.Recipients.Recipient{
          address: %Plaid.PaymentInitiation.Recipients.Recipient.Address{}
        }
      }
    )
  end
end
