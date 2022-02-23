defmodule Plaid.InstitutionsTest do
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
    {:ok, bypass: bypass}
  end

  @moduletag :institutions

  describe "institutions unit test" do
    @describetag :unit

    test "get/1 requests POST and returns Plaid.Institutions" do
      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "institutions/get"
        {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:institutions)}}
      end)

      assert {:ok, %Plaid.Institutions{} = resp} = Plaid.Institutions.get(%{count: 1, offset: 0})
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get/1 returns Plaid.Error" do
      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        {:ok, %HTTPoison.Response{status_code: 400, body: http_response_body(:error)}}
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.get(%{count: 1, offset: 0})
    end

    test "get_by_id/1 requests POST and returns Plaid.Institutions.Institution" do
      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "institutions/get_by_id"
        {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:institution)}}
      end)

      assert {:ok, %Plaid.Institutions.Institution{} = resp} =
               Plaid.Institutions.get_by_id("some_id")

      assert {:ok, _} = Jason.encode(resp)
    end

    test "get_by_id/1 accepts string params" do
      params = "ins_1"

      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    body,
                                                    _headers,
                                                    _options ->
        assert %{institution_id: params} == body
        {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:institution)}}
      end)

      Plaid.Institutions.get_by_id(params)
    end

    test "get_by_id/1 accepts map params" do
      params = %{institution_id: "ins_1"}

      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    body,
                                                    _headers,
                                                    _options ->
        assert params == body
        {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:institution)}}
      end)

      Plaid.Institutions.get_by_id(params)
    end

    test "get_by_id/1 returns Plaid.Error" do
      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        {:ok, %HTTPoison.Response{status_code: 400, body: http_response_body(:error)}}
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.get_by_id("ins_1")
    end

    test "search/1 requests POST and returns Plaid.Institutions" do
      expect(PlaidMock, :make_request_with_cred, fn method,
                                                    endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        assert method == :post
        assert endpoint == "institutions/search"
        {:ok, %HTTPoison.Response{status_code: 200, body: http_response_body(:institutions)}}
      end)

      assert {:ok, %Plaid.Institutions{} = resp} = Plaid.Institutions.search(%{})
      assert {:ok, _} = Jason.encode(resp)
    end

    test "search/1 returns Plaid.Error" do
      expect(PlaidMock, :make_request_with_cred, fn _method,
                                                    _endpoint,
                                                    _config,
                                                    _body,
                                                    _headers,
                                                    _options ->
        {:ok, %HTTPoison.Response{status_code: 400, body: http_response_body(:error)}}
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.search(%{})
    end
  end

  describe "institutions integration tests" do
    @describetag :integration

    test "get/1 returns Plaid.Institutions", %{bypass: bypass} do
      body = http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Institutions.get(%{count: 1, offset: 0})
      assert Plaid.Institutions == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get_by_id/1 returns Plaid.Institutions.Institution",
         %{bypass: bypass} do
      body = http_response_body(:institution)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Institutions.get_by_id("ins_109512")
      assert Plaid.Institutions.Institution == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "search/1 returns Plaid.Institutions", %{bypass: bypass} do
      body = http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Institutions.search(%{query: "wells", products: nil})
      assert Plaid.Institutions == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
