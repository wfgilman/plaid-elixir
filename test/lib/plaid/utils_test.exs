defmodule Plaid.UtilsTest do
  use ExUnit.Case

  import Plaid.Factory

  # These tests could be expanded to verify that individual fields are set correcty.
  describe "utils" do
    test "map_response/2 maps Plaid Categories response" do
      plaid_response = http_response_body(:categories)
      resp = Plaid.Utils.map_response(plaid_response, :categories)

      assert Plaid.Categories == resp.__struct__
    end

    test "map_response/2 maps Plaid Income response" do
      plaid_response = http_response_body(:income)
      resp = Plaid.Utils.map_response(plaid_response, :income)

      assert Plaid.Income == resp.__struct__

      %{
        "income" => %{
          "income_streams" => [
            income_stream_1,
            income_stream_2
          ],
          "last_year_income" => last_year_income,
          "last_year_income_before_tax" => last_year_income_before_tax,
          "max_number_of_overlapping_income_streams" => max_number_of_overlapping_income_streams,
          "number_of_income_streams" => number_of_income_streams,
          "projected_yearly_income" => projected_yearly_income,
          "projected_yearly_income_before_tax" => projected_yearly_income_before_tax
        },
        "item" => _,
        "request_id" => _
      } = plaid_response

      assert last_year_income == resp.income.last_year_income
      assert last_year_income_before_tax == resp.income.last_year_income_before_tax

      assert max_number_of_overlapping_income_streams ==
               resp.income.max_number_of_overlapping_income_streams

      assert number_of_income_streams == resp.income.number_of_income_streams
      assert projected_yearly_income == resp.income.projected_yearly_income
      assert projected_yearly_income_before_tax == resp.income.projected_yearly_income_before_tax

      resp_income_stream_1 = Enum.at(resp.income.income_streams, 0)
      assert income_stream_1["confidence"] == resp_income_stream_1.confidence
      assert income_stream_1["days"] == resp_income_stream_1.days
      assert income_stream_1["monthly_income"] == resp_income_stream_1.monthly_income
      assert income_stream_1["name"] == resp_income_stream_1.name

      resp_income_stream_2 = Enum.at(resp.income.income_streams, 1)
      assert income_stream_2["confidence"] == resp_income_stream_2.confidence
      assert income_stream_2["days"] == resp_income_stream_2.days
      assert income_stream_2["monthly_income"] == resp_income_stream_2.monthly_income
      assert income_stream_2["name"] == resp_income_stream_2.name
    end

    test "map_response/2 maps Plaid Institutions response" do
      plaid_response = http_response_body(:institutions)
      resp = Plaid.Utils.map_response(plaid_response, :institutions)

      assert Plaid.Institutions == resp.__struct__
    end

    test "map_response/2 maps Plaid single institution response" do
      plaid_response = http_response_body(:institution)
      resp = Plaid.Utils.map_response(plaid_response, :institutions)

      assert Plaid.Institutions == resp.__struct__
      assert plaid_response["request_id"] == resp.request_id
    end

    test "map_response/2 maps Plaid Transactions response" do
      plaid_response = http_response_body(:transactions)
      resp = Plaid.Utils.map_response(plaid_response, :transactions)

      assert Plaid.Transactions == resp.__struct__
      assert resp.request_id == plaid_response["request_id"]

      resp_trans = Enum.at(resp.transactions, 0)
      plaid_trans = Enum.at(plaid_response["transactions"], 0)

      assert resp_trans.iso_currency_code == plaid_trans["iso_currency_code"]
      assert resp_trans.unofficial_currency_code == plaid_trans["unofficial_currency_code"]
    end

    test "map_response/2 maps Plaid Accounts response" do
      plaid_response = http_response_body(:accounts)
      resp = Plaid.Utils.map_response(plaid_response, :accounts)

      assert Plaid.Accounts == resp.__struct__

      resp_account = Enum.at(resp.accounts, 0)
      plaid_account = Enum.at(plaid_response["accounts"], 0)

      assert resp_account.balances.iso_currency_code ==
               plaid_account["balances"]["iso_currency_code"]

      assert resp_account.balances.unofficial_currency_code ==
               plaid_account["balances"]["unofficial_currency_code"]
    end

    test "map_response/2 maps Plaid Auth response" do
      plaid_response = http_response_body(:auth)
      resp = Plaid.Utils.map_response(plaid_response, :auth)

      assert Plaid.Auth == resp.__struct__

      account_number =
        plaid_response["numbers"]["ach"]
        |> Enum.at(0)
        |> Map.get("account")

      mapped_account_number = Enum.at(resp.numbers.ach, 0).account
      assert account_number == mapped_account_number
    end

    test "map_response/2 maps Plaid Item response" do
      plaid_response = http_response_body(:item)
      resp = Plaid.Utils.map_response(plaid_response, :item)

      assert Plaid.Item == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
