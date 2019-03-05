defmodule Plaid.CategoriesTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "categories" do
    test "get/0 request POST and returns Plaid.Categories", %{bypass: bypass} do
      body = http_response_body(:categories)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Categories.get()
      assert Plaid.Categories == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
      assert Enum.count(resp.categories) == 1
    end
  end
end
