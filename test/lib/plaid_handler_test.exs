defmodule PlaidHandlerTest do
  use ExUnit.Case, async: true

  import Plaid.Factory

  @moduletag :plaid_handler

  # These tests could be expanded to verify that individual fields are set correcty.
  describe "handle_response/2" do
    @describetag :unit

    test "return Plaid error" do
      resp = {:ok, %HTTPoison.Response{status_code: 400, body: http_response_body(:error)}}
      assert {:error, %Plaid.Error{}} = PlaidHandler.handle_resp(resp, :any)
    end

    test "return HTTPoison error" do
      resp = {:error, %HTTPoison.Error{}}
      assert {:error, %HTTPoison.Error{}} = PlaidHandler.handle_resp(resp, :any)
    end

    test "return Plaid Error when status code > 201" do
      resp = {:ok, %HTTPoison.Response{status_code: 400, body: http_response_body(:accounts)}}
      assert {:error, %Plaid.Error{}} = PlaidHandler.handle_resp(resp, :any)
    end

    test "map categories response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:categories)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :categories)
      assert Plaid.Categories == ds.__struct__
      assert Plaid.Categories.Category = List.first(ds.categories).__struct__
    end

    test "map income response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:income)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :income)
      assert Plaid.Income == ds.__struct__
      assert Plaid.Item == ds.item.__struct__
      assert Plaid.Income.Income == ds.income.__struct__
      assert Plaid.Income.Income.IncomeStream = List.first(ds.income.income_streams).__struct__
    end

    test "map institutions response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:institutions)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :institutions)
      assert Plaid.Institutions == ds.__struct__
      assert Plaid.Institutions.Institution == List.first(ds.institutions).__struct__
    end

    test "map institution response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:institution)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :institution)
      assert Plaid.Institutions.Institution == ds.__struct__
    end

    test "map transactions response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:transactions)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :transactions)
      assert Plaid.Transactions == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Transactions.Transaction == List.first(ds.transactions).__struct__
      assert Plaid.Item == ds.item.__struct__
    end

    test "map accounts response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:accounts)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :accounts)
      assert Plaid.Accounts == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Item == ds.item.__struct__
    end

    test "map auth response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:auth)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :auth)
      assert Plaid.Auth == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Item == ds.item.__struct__
    end

    test "map identity response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:identity)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :identity)
      assert Plaid.Identity == ds.__struct__
      assert Plaid.Item == ds.item.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Accounts.Account.Owner == List.first(List.first(ds.accounts).owners).__struct__
    end

    test "map item response to data structure" do
      resp = {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:item)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :item)
      assert Plaid.Item == ds.__struct__
      assert Plaid.Item.Status == ds.status.__struct__
    end

    test "parse new_access_token from item response" do
      resp =
        {:ok,
         %HTTPoison.Response{status_code: 200, body: http_response_body(:rotate_access_token)}}

      assert {:ok, %{new_access_token: "access-sandbox-7c69d345-fd46"}} =
               PlaidHandler.handle_resp(resp, :item)
    end

    test "parse access_token from item response" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:exchange_public_token)
         }}

      assert {:ok, %{access_token: "access-sandbox-e9317406-8413", item_id: _, request_id: _}} =
               PlaidHandler.handle_resp(resp, :item)
    end

    test "parse public_token from item response" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:create_public_token)
         }}

      assert {:ok,
              %{
                public_token: "public-sandbox-ae89b269-724d-48fe-af9a-cb31c2d1708a",
                expiration: _,
                request_id: _
              }} = PlaidHandler.handle_resp(resp, :item)
    end

    test "parse processor_token from item response" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:processor_token)
         }}

      assert {:ok,
              %{
                processor_token: "processor-sandbox-asda9-a99c1-ca3g",
                request_id: _
              }} = PlaidHandler.handle_resp(resp, :item)
    end

    test "parse stripe_bank_account_token from item response" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:stripe_bank_account_token)
         }}

      assert {:ok,
              %{
                stripe_bank_account_token: "stripe-sandbox-asda9-a99c1-ca3g",
                request_id: _
              }} = PlaidHandler.handle_resp(resp, :item)
    end

    test "parse request_id from item response" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: %{"request_id" => "45QSn"}
         }}

      assert {:ok, %{request_id: "45QSn"}} = PlaidHandler.handle_resp(resp, :item)
    end

    test "map holdings from investment response to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{status_code: 200, body: http_response_body(:"investments/holdings")}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"investments/holdings")
      assert Plaid.Investments.Holdings == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Investments.Security == List.first(ds.securities).__struct__
      assert Plaid.Investments.Holdings.Holding == List.first(ds.holdings).__struct__
      assert Plaid.Item == ds.item.__struct__
    end

    test "map transactions from investment response to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:"investments/transactions")
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"investments/transactions")
      assert Plaid.Investments.Transactions == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Investments.Security == List.first(ds.securities).__struct__

      assert Plaid.Investments.Transactions.Transaction ==
               List.first(ds.investment_transactions).__struct__

      assert Plaid.Item == ds.item.__struct__
    end

    test "map link response to data structure" do
      resp =
        {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:create_link_token)}}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :link)
      assert Plaid.Link == ds.__struct__
      assert Plaid.Link.Metadata == ds.metadata.__struct__
    end

    test "map webhook_verification_key response to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:webhook_verification_key)
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :webhook_verification_key)
      assert Plaid.WebhookVerificationKey == ds.__struct__
      assert ds.key
      assert ds.request_id
    end

    test "map single payment response to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:"payment_initiation/payment/get")
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"payment_initiation/payment")
      assert Plaid.PaymentInitiation.Payments.Payment == ds.__struct__
      assert Plaid.PaymentInitiation.Payments.Payment.Amount == ds.amount.__struct__
    end

    test "map multiple payments response to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:"payment_initiation/payment/list")
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"payment_initiation/payment")
      assert Plaid.PaymentInitiation.Payments == ds.__struct__
      assert Plaid.PaymentInitiation.Payments.Payment == List.first(ds.payments).__struct__

      assert Plaid.PaymentInitiation.Payments.Payment.Amount ==
               List.first(ds.payments).amount.__struct__
    end

    test "map payment/create response to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:"payment_initiation/payment/create")
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"payment_initiation/payment")
      assert Plaid.PaymentInitiation.Payments.Payment == ds.__struct__
      assert ds.payment_id
      assert ds.status
      assert ds.request_id
    end

    test "map single recipient response to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:"payment_initiation/recipient/get")
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"payment_initiation/recipient")
      assert Plaid.PaymentInitiation.Recipients.Recipient == ds.__struct__
      assert Plaid.PaymentInitiation.Recipients.Recipient.Address == ds.address.__struct__
    end

    test "map multiple recipients to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:"payment_initiation/recipient/list")
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"payment_initiation/recipient")
      assert Plaid.PaymentInitiation.Recipients == ds.__struct__
      assert Plaid.PaymentInitiation.Recipients.Recipient == List.first(ds.recipients).__struct__
    end

    test "map recipient/create to data structure" do
      resp =
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: http_response_body(:"payment_initiation/recipient/create")
         }}

      assert {:ok, ds} = PlaidHandler.handle_resp(resp, :"payment_initiation/recipient")
      assert Plaid.PaymentInitiation.Recipients.Recipient == ds.__struct__
      assert ds.recipient_id
      assert ds.request_id
    end
  end
end
