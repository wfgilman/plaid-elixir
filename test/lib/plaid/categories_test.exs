defmodule Plaid.CategoriesTest do
  use ExUnit.Case, async: false

  import Mox
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

  @moduletag :categories

  describe "categories unit tests" do
    @describetag :unit

    test "get/0 requests POST and returns Plaid.Categories" do
      body = http_response_body(:categories)

      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "categories/get"
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}
      end)

      assert {:ok, resp} = Plaid.Categories.get()
      assert Plaid.Categories == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end

  describe "categories integration tests" do
    @describetag :integration

    test "get/0 returns Plaid.Categories", %{bypass: bypass} do
      body = http_response_body(:categories)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Categories.get()
      assert Plaid.Categories == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
      assert Enum.count(resp.categories) == 1
    end
  end
end
