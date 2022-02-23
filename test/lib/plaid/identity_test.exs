defmodule Plaid.IdentityTest do
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

  @moduletag :identity

  describe "identity unit tests" do
    @describetag :unit

    test "get/1 requests POST and returns Plaid.Identity", %{params: params} do
      body = http_response_body(:identity)

      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "identity/get"
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}
      end)

      assert {:ok, resp} = Plaid.Identity.get(params)
      assert Plaid.Identity == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get/1 returns Plaid.Error", %{params: params} do
      body = http_response_body(:error)

      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        {:ok, %HTTPoison.Response{status_code: 400, body: body}}
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Identity.get(params)
    end
  end

  describe "identity integration tests" do
    @describetag :integration

    test "get/1 requests POST and returns Plaid.Identity", %{bypass: bypass, params: params} do
      body = http_response_body(:identity)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Identity.get(params)
      assert Plaid.Identity == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
