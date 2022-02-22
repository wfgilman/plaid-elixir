defmodule Plaid.AccountsTest do
  import Mox
  use ExUnit.Case, async: false

  import Plaid.Factory

  setup context do
    verify_on_exit!()

    bypass =
      if context[:integration] do
        bypass = Bypass.open()
        Application.put_env(:plaid, :client, Plaid)
        Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
        bypass
      end

    on_exit(fn -> Application.put_env(:plaid, :client, PlaidMock) end)
    {:ok, bypass: bypass}
  end

  @moduletag :accounts

  describe "accounts unit tests" do
    @describetag :unit

    test "get/1 requests POST and returns Plaid.Accounts" do
      body = http_response_body(:accounts)

      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "accounts/get"
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}
      end)

      assert {:ok, resp} = Plaid.Accounts.get(%{access_token: "my-token"})
      assert Plaid.Accounts == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get/1 returns error" do
      body = http_response_body(:error)

      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        {:ok, %HTTPoison.Response{status_code: 400, body: body}}
      end)

      assert {:error, resp} = Plaid.Accounts.get(%{access_token: "my-token"})
      assert Plaid.Error == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get_balance/1 requests POST and returns Plaid.Accounts" do
      body = http_response_body(:accounts)

      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "accounts/balance/get"
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}
      end)

      assert {:ok, resp} = Plaid.Accounts.get_balance(%{access_token: "my-token"})
      assert Plaid.Accounts == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end

  describe "accounts integration test" do
    @describetag :integration

    test "get/1 returns Plaid.Accounts", %{bypass: bypass} do
      body = http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Accounts.get(%{access_token: "my-token"})
      assert Plaid.Accounts == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get_balance/1 returns Plaid.Accounts", %{bypass: bypass} do
      body = http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Accounts.get_balance(%{access_token: "my-token"})
      assert Plaid.Accounts == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
