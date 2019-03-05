defmodule Plaid.InstitutionsTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "institutions" do
    test "get/1 requests POST and returns Plaid.Institutions", %{bypass: bypass} do
      body = http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Institutions.get(%{count: 1, offset: 0})
      assert Plaid.Institutions == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get_by_id/1 requests POST and returns Plaid.Institutions.Institution", %{bypass: bypass} do
      body = http_response_body(:institution)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Institutions.get_by_id("ins_109512")
      assert Plaid.Institutions.Institution == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "search/1 requests POST and returns Plaid.Institutions", %{bypass: bypass} do
      body = http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Institutions.search(%{query: "wells", products: nil})
      assert Plaid.Institutions == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
