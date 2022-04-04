defmodule Plaid.AccountsTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
  end

  @moduletag :accounts

  @tag :unit
  test "accounts data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Accounts{
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
             })
  end

  describe "accounts get/2" do
    @tag :unit
    test "submits request with correct parameters", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "accounts/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:accounts)}
      end)

      assert {:ok, ds} = Plaid.Accounts.get(params, config)
      assert Plaid.Accounts == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
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

      body = http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Accounts{}} = Plaid.Accounts.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Accounts.get(params, config)
    end
  end

  describe "accounts get_balance/2" do
    @tag :unit
    test "submits request with correct parameters", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "accounts/balance/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:accounts)}
      end)

      assert {:ok, ds} = Plaid.Accounts.get_balance(params, config)
      assert Plaid.Accounts == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
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

      body = http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Accounts{}} = Plaid.Accounts.get_balance(params, config)
    end

    @tag :integration
    test "error integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Accounts.get(params, config)
    end
  end
end
