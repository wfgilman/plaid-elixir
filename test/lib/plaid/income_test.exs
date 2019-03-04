defmodule Plaid.IncomeTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "income" do
    test "get/1 requests POST and returns Plaid.Income", %{bypass: bypass} do
      body = http_response_body(:income)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Income.get(%{access_token: "my-token"})
      assert Plaid.Income == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
