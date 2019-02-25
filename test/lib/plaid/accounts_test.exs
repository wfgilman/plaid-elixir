defmodule Plaid.AccountsTest do

  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "accounts" do

    test "get/1 requests POST and returns Plaid.Accounts", %{bypass: bypass} do
      body = http_response_body(:accounts)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Accounts.get(%{access_token: "my-token"})
      assert Plaid.Accounts == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get/1 requests POST and returns error", %{bypass: bypass} do
      body = http_response_body(:error)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 400, Poison.encode!(body))
      end

      assert {:error, resp} = Plaid.Accounts.get(%{access_token: "my-token"})
      assert Plaid.Error == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get_balance/1 requests POST and returns Plaid.Accounts", %{bypass: bypass} do
      body = http_response_body(:accounts)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Accounts.get(%{access_token: "my-token"})
      assert Plaid.Accounts == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

  end
end
