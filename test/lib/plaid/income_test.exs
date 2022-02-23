defmodule Plaid.IncomeTest do
  use ExUnit.Case

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
    {:ok, bypass: bypass, params: %{access_token: "my-token"}}
  end

  @moduletag :income

  describe "income unit tests" do
    @describetag :unit

    test "get/1 requests POST and returns Plaid.Income", %{params: params} do
      body = http_response_body(:income)

      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "income/get"
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}
      end)

      assert {:ok, %Plaid.Income{} = resp} = Plaid.Income.get(params)
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get/1 requests Plaid.Error", %{params: params} do
      body = http_response_body(:error)

      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        {:ok, %HTTPoison.Response{status_code: 400, body: body}}
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Income.get(params)
    end
  end

  describe "income integration tests" do
    @describetag :integration
    test "get/1 requests POST and returns Plaid.Income", %{bypass: bypass, params: params} do
      body = http_response_body(:income)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "income/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Income.get(params)
      assert Plaid.Income == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
