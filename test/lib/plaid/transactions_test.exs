defmodule Plaid.TransactionsTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()

    {:ok,
     params: %{access_token: "my-token"},
     config: %{
       client: PlaidMock,
       client_id: "test_id",
       secret: "test_secret",
       root_uri: "http://localhost:4000/"
     }}
  end

  @moduletag :transactions

  @tag :unit
  test "transactions data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Transactions{
               accounts: [%Plaid.Accounts.Account{}],
               item: %Plaid.Item{},
               transactions: [
                 %Plaid.Transactions.Transaction{
                   location: %Plaid.Transactions.Transaction.Location{},
                   payment_meta: %Plaid.Transactions.Transaction.PaymentMeta{},
                   personal_finance_category:
                     %Plaid.Transactions.Transaction.PersonalFinanceCategory{}
                 }
               ]
             })
  end

  describe "transactions get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "transactions/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:transactions)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.Transactions.get(params, config)
      assert Plaid.Transactions == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Transactions.Transaction == List.first(ds.transactions).__struct__
      assert Plaid.Item == ds.item.__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:transactions)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Transactions{}} = Plaid.Transactions.get(params, config)
    end

    @tag :integration
    test "error integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Transactions.get(params, config)
    end
  end

  describe "transactions sync/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "transactions/sync"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:transactions_sync)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.Transactions.sync(params, config)
      assert Plaid.Transactions.Sync == ds.__struct__
      assert Plaid.Transactions.Transaction == List.first(ds.added).__struct__
      assert Plaid.Transactions.Transaction == List.first(ds.modified).__struct__
      assert Plaid.Transactions.RemovedTransaction == List.first(ds.removed).__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:transactions_sync)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Transactions.Sync{}} = Plaid.Transactions.sync(params, config)
    end

    @tag :integration
    test "error integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Transactions.sync(params, config)
    end
  end
end
