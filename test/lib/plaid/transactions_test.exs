defmodule Plaid.TransactionsTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "transactions" do
    test "transactions/1 requests POST and returns Plaid.Transactions", %{bypass: bypass} do
      body = http_response_body(:transactions)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "transactions/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.Transactions.get(%{
                 access_token: "my-token",
                 start_date: "2017-01-01",
                 end_date: "2017-01-31"
               })
      assert Plaid.Transactions == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
