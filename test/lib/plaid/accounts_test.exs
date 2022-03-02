defmodule Plaid.AccountsTest do
  use ExUnit.Case, async: true

  import Mox

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
    test "makes post call to accounts/get endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "accounts/get"
        {:ok, %HTTPoison.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :accounts
        {:ok, %Plaid.Accounts{}}
      end)

      assert {:ok, %Plaid.Accounts{}} = Plaid.Accounts.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Accounts.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Accounts data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Accounts{}} = Plaid.Accounts.get(params, config)
    end

    @tag :integration
    test "returns Plaid.Error", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Accounts.get(params, config)
    end
  end

  describe "accounts get_balance/2" do
    @tag :unit
    test "makes post request to accounts/balance/get endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "accounts/balance/get"
        {:ok, %HTTPoison.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :accounts
        {:ok, %Plaid.Accounts{}}
      end)

      assert {:ok, %Plaid.Accounts{}} = Plaid.Accounts.get_balance(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Accounts.get_balance(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Accounts data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Accounts{}} = Plaid.Accounts.get_balance(params, config)
    end

    @tag :integration
    test "returns Plaid.Error", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Accounts.get(params, config)
    end
  end
end
