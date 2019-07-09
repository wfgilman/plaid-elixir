defmodule Plaid.InvestmentsTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "investments/transactions" do
    test "get/1 requests POST and returns Plaid.Investments.Transactions", %{
      bypass: bypass
    } do
      body = http_response_body(:"investments/transactions")

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "investments/transactions/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.Investments.Transactions.get(%{
                 access_token: "my-token",
                 start_date: "2017-01-01",
                 end_date: "2017-01-31"
               })

      assert Plaid.Investments.Transactions == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end

  describe "investments/holdings" do
    test "get/1 requests POST and returns Plaid.Investments.Holdings", %{bypass: bypass} do
      body = http_response_body(:"investments/holdings")

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "investments/holdings/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.Investments.Holdings.get(%{
                 access_token: "my-token"
               })

      assert Plaid.Investments.Holdings == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
