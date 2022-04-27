defmodule Plaid.AssetReportTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()

    {:ok,
     options: %{client_report_id: "123"},
     config: %{
       client: PlaidMock,
       client_id: "test_id",
       secret: "test_secret",
       root_uri: "http://localhost:4000/"
     }}
  end

  describe "asset create_asset_report/4" do
    @tag :unit
    test "submits request and unmarshalls response", %{options: options, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "asset_report/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:create_asset_report)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} =
               Plaid.AssetReport.create_asset_report(["test-token"], 365, options, config)

      assert r.asset_report_token
      assert r.asset_report_id
      assert r.request_id
    end

    @tag :integration
    test "success integration test", %{options: options} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:create_asset_report)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok,
              %Plaid.AssetReport.Request{asset_report_id: _, asset_report_token: _, request_id: _}} =
               Plaid.AssetReport.create_asset_report(["test-token"], 365, options, config)
    end
  end

  describe "asset get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "asset_report/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:get_asset_report)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.AssetReport.get("test-token", true, config)
      assert r.report
      assert r.warnings
      assert r.request_id
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:get_asset_report)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.AssetReport{report: _, warnings: _, request_id: _}} =
               Plaid.AssetReport.get("test-token", true, config)
    end
  end
end
